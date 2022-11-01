#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

echo -e "${bold}-------------------------------------- REMOVING OLD APP IMAGE -----------------------------------------${normal}"
docker rmi embedash:1.1-SNAPSHOT 644435390668.dkr.ecr.eu-central-1.amazonaws.com/adam-ted:latest
pushd ./environment > /dev/null
terraform destroy -auto-approve -var-file dev.tfvars
popd > /dev/null
echo -e "${bold}------------------------------------ BUILDING THE TED SEARCH APP --------------------------------------${normal}"
pushd ./app > /dev/null
mvn clean verify
popd > /dev/null
echo -e "${bold}----------------------------------- PUSHING THE IMAGE TO ECR REPO -------------------------------------${normal}"
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-central-1.amazonaws.com
docker tag embedash:1.1-SNAPSHOT 644435390668.dkr.ecr.eu-central-1.amazonaws.com/adam-ted:latest
docker push 644435390668.dkr.ecr.eu-central-1.amazonaws.com/adam-ted:latest
echo -e "${bold}----------------------------------- PROVISION THE INFRASTRUCTURE --------------------------------------${normal}"
pushd ./environment > /dev/null
terraform apply -auto-approve -var-file dev.tfvars
DYNAMIC_IP=$(terraform output -raw public_ip)
popd > /dev/null
echo "${bold}Server booting...${normal}"
sleep 40
echo -e "${bold}----------------------------- COPYING THE APP SOURCE FILES INTO THE SERVER ----------------------------${normal}"
scp -o StrictHostKeyChecking=no -i ./adam-lab.pem -r ./app/reverse_proxy ubuntu@$DYNAMIC_IP:~/
scp -o StrictHostKeyChecking=no -i ./adam-lab.pem ./app/aws_configure.sh ubuntu@$DYNAMIC_IP:~/
scp -o StrictHostKeyChecking=no -i ./adam-lab.pem ./app/docker-compose.yaml ubuntu@$DYNAMIC_IP:~/
echo -e "${bold}----------------------------- LOGGING INTO THE SERVER USING SSH PROTOCOL ------------------------------${normal}"
ssh -o StrictHostKeyChecking=no -i ./adam-lab.pem ubuntu@$DYNAMIC_IP << EOF
echo -e "${bold}------------------------------------- CONFIGURATION OF DOCKER -----------------------------------------${normal}"
sudo snap install docker
echo -e "${bold}----------------------------------- CONFIGURATION OF AWS PROFILE --------------------------------------${normal}"
command ./aws_configure.sh
echo -e "${bold}-------------------------------- PULLING THE APP IMAGE FROM ECR REPO ----------------------------------${normal}"
sudo docker pull 644435390668.dkr.ecr.eu-central-1.amazonaws.com/adam-ted:latest
echo -e "${bold}--------------------------------- RUNNING MULTISERVICE ARCHITECTURE -----------------------------------${normal}"
sudo docker-compose up --detach
EOF
echo "${bold}----------------------------------------------- E2E TESTING ----------------------------------------------${normal}"
echo "${bold}Application running up...${normal}"
sleep 10
pushd ./app > /dev/null
./e2e_tests.sh
popd > /dev/null
