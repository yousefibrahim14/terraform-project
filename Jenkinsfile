pipeline {
    agent any

    environment {
        RDS_PASSWORD = credentials('rds-password')
    }

    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'prod'],
            description: 'Select Terraform environment'
        )
    }

    stages {

        stage('Test Credentials') {
            steps {
                sh '''
                    if [ -n "$RDS_PASSWORD" ]; then
                        echo "RDS password is available"
                    else
                        echo "RDS password is NOT available"
                        exit 1
                    fi
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Select Workspace') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh 'terraform workspace select "$ENV"'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh 'terraform plan -input=false'
                }
            }
        }
    }
}
