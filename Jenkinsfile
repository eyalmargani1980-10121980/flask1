pipeline {
    agent any

    environment {
        IMAGE_NAME = 'eyalmargani1980/flask-hello-world'
        KUBECONFIG = '/var/jenkins_home/.kube/config'
    }

    stages {
        stage('Code Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Build+Tag') {
            steps {
                script {
                    def dockerImage = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                    def dockerImageTagLatest = docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        def dockerImage = docker.image("${IMAGE_NAME}:${BUILD_NUMBER}")
                        def dockerImageTagLatest = docker.image("${IMAGE_NAME}:latest")
                        dockerImage.push("${BUILD_NUMBER}")
                        dockerImageTagLatest.push('latest')
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }
}
