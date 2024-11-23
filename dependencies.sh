#!/bin/bash
# Variables for the the software dependency versions
TF_VERSION="1.0.9"
# Update all the software underlying dependencies
apt update -y && sudo apt upgrade -y
#install unzip 
apt install unzip -y
# Install AWS CLI package and verify version
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o  awscliv2.zip
./aws/install
aws --version
# Install Git and verify version
apt install git -y
git --version
#Docker installation and verify version
apt install docker.io -y
systemctl start docker
systemctl enable docker
docker --version
# Install Terraform and verify version 
wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip
unzip terraform_${TF_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin
rm terraform_${TF_VERSION}_linux_amd64.zip
# Install kubectl and verify version 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# Install Helm and verify version
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh
helm version
