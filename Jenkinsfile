pipeline {
    agent any

    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'prod'],
            description: 'Select Terraform environment'
        )
    }

    stages {

        stage('Prepare Variables') {
            steps {
                withCredentials([
                    string(
                        credentialsId: 'rds-password',
                        variable: 'RDS_PASSWORD'
                    )
                ]) {
                    sh '''
                        cp "${ENV}.tfvars.example" terraform.tfvars

                        printf '\\ndb_password = "%s"\\n' "$RDS_PASSWORD" >> terraform.tfvars

                        chmod 600 terraform.tfvars

                        echo "Terraform variables prepared for ${ENV}"
                    '''
                }
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

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
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

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh 'terraform apply -input=false -auto-approve'
                }
            }
        }

        stage('Deploy Node.js App') {
            when {
                expression {
                    params.ENV == 'dev'
                }
            }

            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                        ssh \
                          -o StrictHostKeyChecking=no \
                          -o UserKnownHostsFile=/dev/null \
                          -o "ProxyCommand=ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p ubuntu@44.199.246.55" \
                          ubuntu@10.0.2.176 \
                          "mkdir -p ~/node-app"

                        scp \
                          -o StrictHostKeyChecking=no \
                          -o UserKnownHostsFile=/dev/null \
                          -o "ProxyCommand=ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p ubuntu@44.199.246.55" \
                          app.js \
                          ubuntu@10.0.2.176:~/node-app/app.js

                        ssh \
                          -o StrictHostKeyChecking=no \
                          -o UserKnownHostsFile=/dev/null \
                          -o "ProxyCommand=ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p ubuntu@44.199.246.55" \
                          ubuntu@10.0.2.176 \
                          "cd ~/node-app && nohup node app.js > app.log 2>&1 &"
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'rm -f terraform.tfvars'
        }
    }
}
