# Monitoring Setup with Prometheus and Grafana

## Introduction
This sets up a complete monitoring and alerting system for docker containers using **Prometheus, Grafana** and **Alertmanager** to help track our infrastructure's health and performance in real time.

With **Prometheus**, we gather and store time-series data about system resources like CPU, memory, disk and network usage. **Grafana** helps us to vizualize all the data that we gather from Prometheus. We can interact with the data, making it easy to get trends, identify issues and track performance over time. if something goes wrong, the **Alertmanager** sends alerts to notify us based on the alert rules that we set. by this we can ensure to respond quickly to any critical situations.

In this assessment, **Node Exporter** collects important metrics from the host system, while cAdvisor collects metrics from the containers. Together, they provide a full picture of both underlying hardware and the docker containers running on top of the host machine.

The project is designed to be scalable and flexible, suitable for anything from a small test system to a full production system. whether we are monitoring few containers or a whole infrastructure, this helps to find performance issues and minimizing downtime. 

## Tools Used
- Prometheus
- Alertmanager
- Grafana
- Node Exporter
- cAdvisor
- Docker and Docker compose
- Slack

## Setup
### 1. Install Docker
$ sudo yum update -y
$ sudo yum install docker -y
$ sudo systemctl start docker

### 2. Install Docker Compose
$
$

### Clone the Repository
$ git clone https://github.com/Lsrirang/Monitoring.git
$ cd Monitoring
$ git checkout master
$ vim alertmanager.yml (change the slack_webhook_url and channel accordingly)

### Start the containers
$ docker-compose up -d

### Access the containers with the ports
-> Prometheus - http://<public-ip-addr>:9090
-> Grafana - http://<public-ip-addr>:3000
-> Alertmanager - http://<public-ip-addr>:9093
-> Zomatoapp(node.js) - http://<public-ip-addr>:3001

## Setting up Grafana for visualization
### Login to Grafana
- Username: admin
- Password: admin
- you will be asked to change the password

### Add Prometheus as a Data Source
- **Data Source** -> add data source
- Choose Prometheus
- Set the URL to http://<public-ip-addr>:9090
- Select Save and Test (you can see a message that data source is working in green)

### Import a Dashboard
- Top left click + icon -> import Dashboard
- Enter dashboard ID 193/1860 for docker container/node exporter full
- Select Prometheus as the Data Source
- click on Import

## Alerts set in the project
Prometheus will trigger alerts based on the rules that are mentioned in alert.rules. when the alerts are active/fired these are forwarded to Alertmanager which then sends them to the Slack. To make sure that our alert setup is working (to check integration between Prometheus, Alertmanager and slack), i have set a dummy alert that fires always.
## Node Exporter Alerts
### Alert	                       Description
HostHighCPUUsage	           CPU usage > 85% for 2 minutes
HostHighMemoryUsage	         Memory usage > 90%
HostDiskFull	               Disk usage > 90%
NodeDown	                   Node Exporter is down

## cAdvisor Alerts
### Alert	                       Description
ContainerHighCPUUsage	       Container CPU > 85%
ContainerHighMemoryUsage	   Container memory > 90%
ContainerRestartLoop	       Restart count > 1 in 5 minutes
cAdvisorDown	               cAdvisor not reachable
DummyAlwaysFiringAlert	     Always firing (for testing purpose only)

## Future Developments
- in this project we are monitoring system and container health only. we have deployed a Node.js application, we can also monitor at the application level by tracking things like API response times, error rates, and queue size.
- if we are deploying this to production we have to lock it down by adding OAuth to secure access to Prometheus, Grafana and Alertmanager.
- we can automate everything with terraform to make the monitoring stack reusable and version controlled to save errors made by human.










