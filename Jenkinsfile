pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('azure-client-id')
        ARM_CLIENT_SECRET   = credentials('azure-client-secret')
        ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
        ARM_TENANT_ID       = credentials('azure-tenant-id')
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Fetching Terraform code from Git...'
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                dir('terraform') {  // run inside the terraform folder
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo 'Planning Terraform deployment...'
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Apply Terraform plan?', ok: 'Deploy'
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Post-Deployment Test') {
            steps {
                echo 'Running post-deployment checks...'
                dir('terraform') {
                    sh 'terraform output'
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform deployment completed successfully ✅'
        }
        failure {
            echo 'Pipeline failed ❌ — check logs.'
        }
    }
}
