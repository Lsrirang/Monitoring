#--docker installations steps
sudo yum install docker -y 
sudo systemctl start docker
sudo systemctl status docker

#--docker compose installation step
#sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#ls /usr/local/bin/
#sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose
#docker-compose version
#
#--installation of git
#sudo yum install git -y
#
#--Cloning the repository
#git clone https://github.com/Lsrirang/Monitoring.git
#
#--modify the alertmanager with your slack credentials(webhook_url and channel)
#cd Monitoring
#git checkout master
#vim alertmanager.yml #modify url and channel in this file
#
#sudo docker-compose up -d
#
