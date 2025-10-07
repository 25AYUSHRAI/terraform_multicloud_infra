pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('azure-client-id')        // Service Principal App ID
        ARM_CLIENT_SECRET    = credentials('azure-client-secret')    // Service Principal Password
        ARM_SUBSCRIPTION_ID  = credentials('azure-subscription-id')  // Azure Subscription ID
        ARM_TENANT_ID        = credentials('azure-tenant-id')        // Azure Tenant ID
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
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                echo 'Planning Terraform deployment...'
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Apply Terraform plan?', ok: 'Deploy'
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Post-Deployment Test') {
            steps {
                echo 'Running post-deployment checks...'
                // Example: validate output or check Azure resource
                sh 'terraform output'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Terraform deployment completed successfully ✅'
        }
        failure {
            echo 'Pipeline failed ❌ — check logs.'
        }
    }
}
