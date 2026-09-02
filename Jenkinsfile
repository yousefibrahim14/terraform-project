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
    }

    post {
        always {
            sh 'rm -f terraform.tfvars'
        }
    }
}
