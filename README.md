# Monitoring Setup with Prometheus and Grafana

## 1. Introduction
This sets up a complete monitoring and alerting system for docker containers using **Prometheus, Grafana** and **Alertmanager** to help track our infrastructure's health and performance in real time.

With **Prometheus**, we gather and store time-series data about system resources like CPU, memory, disk and network usage. **Grafana** helps us to vizualize all the data that we gather from Prometheus. We can interact with the data, making it easy to get trends, identify issues and track performance over time. if something goes wrong, the **Alertmanager** sends alerts to notify us based on the alert rules that we set. by this we can ensure to respond quickly to any critical situations.

In this assessment, **Node Exporter** collects important metrics from the host system, while cAdvisor collects metrics from the containers. Together, they provide a full picture of both underlying hardware and the docker containers running on top of the host machine.

The project is designed to be scalable and flexible, suitable for anything from a small test system to a full production system. whether we are monitoring few containers or a whole infrastructure, this helps to find performance issues and minimizing downtime. 

## 2. Tools Used
- Prometheus
- Alertmanager
- Grafana
- Node Exporter
- cAdvisor
- Docker and Docker compose
- Slack

## 3. Setup
## 3.1 Prerequisites
AWS EC2 instance or a similar VM running Amazon Linux 2 or a compatible Linux-based OS.
#### Basic requirements for EC2 instance:
- AMI: Amazon Linux 2 (5.1 Kernel)
- Instance Type: t2.micro
- Security Group: Open ports 22, 3000, 3001, 8080, 9090, 9093, 9100
- Key Pair: Create or select one for SSH access

## 3.2 Slack Webhook Setup

To enable Slack alert notifications via Alertmanager, follow these steps:

### Create a Slack Webhook

1. Visit [Slack API Apps](https://api.slack.com/apps)  
2. Click **Create New App** → choose **From Scratch**
3. Give your app a name and select your workspace
4. In the left sidebar, go to **Incoming Webhooks**
5. Toggle **Activate Incoming Webhooks** to **On**
6. Click **Add New Webhook to Workspace**
7. Select the desired Slack channel (e.g., `#alerts`) and click **Allow**
8. Copy the generated **Webhook URL**

### Find Your Webhook URL Later

To retrieve your webhook URL anytime:

- Go to [Your Slack Apps](https://api.slack.com/apps)
- Click on your created app
- Navigate to **Incoming Webhooks**
- Your Webhook URLs will be listed under **Webhook URLs for Your Workspace**

## 3.3 Script-Based setup (Recommanded)

Follow these steps to quickly set up the environment:
> ✅ **Note:** You can skip the manual installation and configuration steps in 3.4 if you are running the setup script using the command below:
To download the `setupscript.sh` file directly from the GitHub repository, use the following command:
```bash
wget https://raw.githubusercontent.com/Lsrirang/Monitoring/master/setupscript.sh
bash setupscript.sh
```
This script will do the following
- Install Docker
- Install Docker Compose
- Install Git
- Clone the repository
- Start the Docker containers

## 3.4 Manual Installation and configuration steps
### 3.4.1 Install Docker
<pre>
$ sudo yum update -y
$ sudo yum install docker -y
$ sudo systemctl start docker
</pre>

### 3.4.2 Install Docker Compose
<pre> 
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ ls /usr/local/bin/
$ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ docker-compose version
</pre>

### 3.4.3 Install Git
<pre>
$ sudo yum install git -y
</pre>

### 3.4.4 Clone the Repository
``` 
git clone https://github.com/Lsrirang/Monitoring.git
cd Monitoring
git checkout master
``` 
### 3.4.5 Configure the Alertmanager configuration file with your Slack settings slack_webhook_url and channel
```
vim alertmanager.yml 
```

### 3.4.6 Start the containers
<pre>
 $ sudo docker-compose up -d 
</pre>

## 4. Access the containers with the ports
- Prometheus - http://<public-ip-addr>:9090
- Grafana - http://<public-ip-addr>:3000
- Alertmanager - http://<public-ip-addr>:9093
- Zomatoapp(node.js) - http://<public-ip-addr>:3001
Replace <public-ip-addr> with the public IP of your EC2 instance.

## 5. Setting up Grafana for visualization
### 5.1 Login to Grafana
- Username: admin
- Password: admin
- you will be asked to change the password

### 5.2 Add Prometheus as a Data Source
- **Data Source** -> add data source
- Choose Prometheus
- Set the URL to http://<public-ip-addr>:9090
- Select Save and Test (you can see a message that data source is working in green)

### 5.3 Import a Dashboard
- Top left click + icon -> import Dashboard
- Enter dashboard ID 193/1860 for docker container/node exporter full
- Select Prometheus as the Data Source
- click on Import

## 6. Alerts set 
Prometheus will trigger alerts based on the rules that are mentioned in alert.rules. when the alerts are active/fired these are forwarded to Alertmanager which then sends them to the Slack. To make sure that our alert setup is working (to check integration between Prometheus, Alertmanager and slack), i have set a dummy alert that fires always.
## 6.1 Node Exporter Alerts

| Alert Name                | Description                      |
|---------------------------|----------------------------------|
| `HostHighCPUUsage`        | CPU usage > 85% for 2 minutes    |
| `HostHighMemoryUsage`     | Memory usage > 90%               |
| `HostDiskFull`            | Disk usage > 90%                 |
| `NodeDown`                | Node Exporter is down            |

## 6.2 cAdvisor Alerts

| Alert Name                | Description                           |
|---------------------------|---------------------------------------|
| `ContainerHighCPUUsage`   | Container CPU > 85%                   |
| `ContainerHighMemoryUsage`| Container memory > 90%               |
| `ContainerRestartLoop`    | Restart count > 1 in 5 minutes        |
| `cAdvisorDown`            | cAdvisor not reachable                |
| `DummyAlwaysFiringAlert`  | Always firing (for testing purpose)  |


## 7. Future Developments
- in this project we are monitoring system and container health only. we have deployed a Node.js application, we can also monitor at the application level by tracking things like API response times, error rates, and queue size.
- if we are deploying this to production we have to lock it down by adding OAuth to secure access to Prometheus, Grafana and Alertmanager.
- we can automate everything with terraform to make the monitoring stack reusable and version controlled to save errors made by human.
