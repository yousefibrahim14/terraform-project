FROM jenkins/jenkins:latest

USER root

RUN apt-get update && \
    apt-get install -y wget unzip curl && \
    wget https://releases.hashicorp.com/terraform/1.13.3/terraform_1.13.3_linux_amd64.zip && \
    unzip terraform_1.13.3_linux_amd64.zip -d /usr/local/bin/ && \
    rm terraform_1.13.3_linux_amd64.zip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip && \
    terraform version && \
    aws --version

USER jenkins
