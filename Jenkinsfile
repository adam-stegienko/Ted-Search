pipeline {
    agent any
    tools {
        maven 'Maven 3.6.2'
        jdk 'JDK 8'
        terraform 'terraform'
    }
    environment {
        GITLAB = credentials('a31843c7-9aa6-4723-95ff-87a1feb934a1')
        AWS_CREDS = credentials('aws-adam-iam')
    }
    stages {
        stage('Cleaning') {
            steps {
                script {
                    deleteDir()
                    checkout scm
                }
            }
        }
        stage('Properties Set-up') {
            steps {
                script {
                    properties([
                        disableConcurrentBuilds(), 
                        gitLabConnection(gitLabConnection: 'GitLab API Connection', jobCredentialId: ''),
                    ])
                }
            }
        }
        stage('Condition Tree') {
            steps {
                script {
                    E2E_CHECKER = sh(
                        script: "git log --format=\"medium\" -1 | grep '#test' || true",
                        returnStdout: true,
                    )
                }
            }
        }
        stage('Removing Old App Image') {
            steps {
                script {
                    sh"""
                    echo -e "-------------------------------------- REMOVING OLD APP IMAGE -----------------------------------------"
                    docker rmi embedash:1.1-SNAPSHOT 644435390668.dkr.ecr.eu-central-1.amazonaws.com/adam-ted:latest || true
                    """
                }
            }
        }
        stage('Bulding App') {
            steps {
                dir('app') {
                    script {
                        sh"""
                        echo -e "------------------------------------ BUILDING THE TED SEARCH APP --------------------------------------"
                        mvn clean verify
                        """
                    }
                }
            }
        } 
        stage('Pushing Image to ECR') {
            steps {
                script {
                    sh"""
                    echo -e "----------------------------------- PUSHING THE IMAGE TO ECR REPO -------------------------------------"
                    aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-central-1.amazonaws.com
                    docker tag embedash:1.1-SNAPSHOT 644435390668.dkr.ecr.eu-central-1.amazonaws.com/adam-ted:latest
                    docker push 644435390668.dkr.ecr.eu-central-1.amazonaws.com/adam-ted:latest
                    """
                }
            }
        }
        stage('Provisioning New Dev Infrastructure') {
            when {
                expression {
                    (E2E_CHECKER)
                }
            }
            steps {
                dir('environment') {
                    script {
                        sh"""
                        echo -e "----------------------------------- PROVISION DEV INFRASTRUCTURE --------------------------------------"
                        terraform init
                        terraform workspace select dev
                        terraform destroy -auto-approve -var-file dev.tfvars
                        terraform apply -auto-approve -var-file dev.tfvars
                        """
                        DYNAMIC_IP = sh(
                        script: "terraform output -raw public_ip",
                        returnStdout: true,
                        )
                    }
                }
            }
        }
        stage('Updating Prod Infrastructure') {
            when {
                expression {
                    !(E2E_CHECKER)
                }
            }
            steps {
                dir('environment') {
                    script {
                        sh"""
                        echo -e "----------------------------------- UPDATE PRODUCTION INFRASTRUCTURE -----------------------------------"
                        terraform init
                        terraform workspace select prod
                        terraform apply -auto-approve -var-file prod.tfvars
                        """
                        DYNAMIC_IP = sh(
                        script: "terraform output -raw public_ip",
                        returnStdout: true,
                        )
                    }
                }
            }
        }
        stage('Booting Server') {
            steps {
                script {
                    sh"""
                    echo "Server booting..."
                    sleep 40
                    """       
                }
            }
        }
        stage('Copying Files Into Server') {
            steps {
                script {
                    sh"""
                    echo -e "----------------------------- COPYING THE APP SOURCE FILES INTO THE SERVER ----------------------------"
                    scp -o StrictHostKeyChecking=no -i "/var/jenkins_home/adam-lab.pem" -r ./app/reverse_proxy ubuntu@${DYNAMIC_IP}:~/
                    scp -o StrictHostKeyChecking=no -i "/var/jenkins_home/adam-lab.pem" ./app/docker-compose.yaml ubuntu@${DYNAMIC_IP}:~/
                    """
                }
            }
        }
        stage('EC2 Configuration + App Booting') {
            steps {
                script {
                    sh"""
                    echo -e "----------------------------- LOGGING INTO THE SERVER USING SSH PROTOCOL ------------------------------"
                    ssh -o StrictHostKeyChecking=no -i "/var/jenkins_home/adam-lab.pem" ubuntu@${DYNAMIC_IP}  << EOF
                    echo -e "------------------------------------- CONFIGURATION OF DOCKER ----------------------------------------"
                    curl https://get.docker.com/ > dockerinstall && chmod 777 dockerinstall && ./dockerinstall
                    sudo apt install docker-compose -y
                    echo -e "----------------------------------- CONFIGURATION OF AWS PROFILE --------------------------------------"
                    sudo apt install awscli -y
                    printf "%s\n%s\neu-central-1\njson" "$AWS_ACCESS_KEY_ID" "$AWS_SECRET_ACCESS_KEY" | aws configure
                    aws ecr get-login-password --region eu-central-1 | sudo docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-central-1.amazonaws.com
                    echo -e "-------------------------------- PULLING THE APP IMAGE FROM ECR REPO ----------------------------------"
                    sudo docker pull 644435390668.dkr.ecr.eu-central-1.amazonaws.com/adam-ted:latest
                    echo -e "--------------------------------- RUNNING MULTISERVICE ARCHITECTURE -----------------------------------"
                    sudo docker-compose up --detach
                    << EOF
                    """
                }
            }
        }
        stage('E2E Testing') {
            steps {
                dir('app') {
                    script {
                        sh"""
                        echo "----------------------------------------------- E2E TESTING ----------------------------------------------"
                        echo "Application running up..."
                        sleep 10
                        ./e2e_tests.sh
                        """
                    }
                }
            }
        }        
    }
}
