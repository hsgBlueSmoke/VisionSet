export DOCKER_COMPOSE_VERSION=3.8
export NETWORK_NAME=ens3
export USERNAME=ubuntu
export PASSWORD=ubuntu

# Prepare Environment Variables 
#export PUBLIC_IP=$(curl ipinfo.io/ip)
export DOCKER_HOST_IP=$(ip addr show ${NETWORK_NAME} | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
export CVAT_HOST=$DOCKER_HOST_IP

# allow login by password
sudo sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
echo "${USERNAME}:${PASSWORD}"|chpasswd
sudo service sshd restart

# add alias "dataplatform" to /etc/hosts
echo "$DOCKER_HOST_IP     dataplatform" | sudo tee -a /etc/hosts

# Install Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable edge"
sudo apt-get install -y docker-ce
sudo usermod -aG docker $USERNAME

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install Platys
#sudo curl -L "https://github.com/TrivadisPF/platys/releases/download/${PLATYS_VERSION}/platys_${PLATYS_VERSION}_linux_x86_64.tar.gz" -o #/tmp/platys.tar.gz
#tar zvxf /tmp/platys.tar.gz 
#sudo mv platys /usr/local/bin/
#sudo chown root:root /usr/local/bin/platys
#sudo rm /tmp/platys.tar.gz 

# Install various Utilities
#sudo apt-get install -y curl jq kafkacat tmux

# needed for elasticsearch
#sudo sysctl -w vm.max_map_count=262144   

# Get the project
#cd /home/${USERNAME} 
#git clone https://github.com/${GITHUB_OWNER}/${GITHUB_PROJECT}
#chown -R ${USERNAME}:${PASSWORD} ${GITHUB_PROJECT}

#cd /home/${USERNAME}/${GITHUB_PROJECT}/01-environment/docker

# Make Environment Variables persistent
#sudo echo "export PUBLIC_IP=$PUBLIC_IP" | sudo tee -a /etc/profile.d/platys-platform-env.sh
#sudo echo "export DOCKER_HOST_IP=$DOCKER_HOST_IP" | sudo tee -a /etc/profile.d/platys-platform-env.sh

# Startup Environment
#docker-compose up -d
