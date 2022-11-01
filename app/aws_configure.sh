#!/bin/bash

KEY_ID="your-key-id"
SECRET_KEY="your-secret-key"

sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
printf "%s\n%s\neu-central-1\njson" "$KEY_ID" "$SECRET_KEY" | aws configure
aws ecr get-login-password --region eu-central-1 | sudo docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-central-1.amazonaws.com