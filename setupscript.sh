#--docker installations steps
echo "----- Checking Docker -----"
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker..."
    sudo yum install docker -y 
    sudo systemctl start docker
    sudo systemctl status docker
else
    echo "Docker is already installed."
fi

#--checking and installing docker compose 
echo "----- Checking Docker Compose -----"
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose not found. Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    ls /usr/local/bin/
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose version
else
    echo "Docker Compose is already installed."
fi

#--Checking and installating git
echo "----- Checking Git -----"
if ! command -v git &> /dev/null; then
    echo "----- Installing Git -----"
    sudo yum install git -y
else
    echo "Git is already installed."
fi

#--Cloning the repository
echo "----- Cloning the Monitoring Repository -----"
git clone https://github.com/Lsrirang/Monitoring.git
cd Monitoring
git checkout master

#--modify the alertmanager with your slack credentials(webhook_url and channel)
echo "----- Please modify alertmanager.yml with your Slack Webhook URL and Channel -----"
echo "Opening alertmanager.yml..."
sleep 10
vim alertmanager.yml #modify url and channel in this file

sudo docker-compose up -d

