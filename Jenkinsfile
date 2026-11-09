pipeline {
    agent any

    environment {
        IMAGE_NAME = 'eyalmargani1980/flask-hello-world'
    }

    stages {
        // שלב 1: משיכת הקוד מ-Git
        stage('Code Checkout') {
            steps {
                checkout scm
            }
        }

        // שלב 2: בנייה ותיוג של האימג' ב-Docker
        stage('Docker Build+Tag') {
            steps {
                script {
                    def dockerImage = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                    def dockerImageTagLatest = docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        // שלב 3: העלאת האימג' ל-DockerHub
        stage('Docker Push') {
            steps {
                script {
                    // העברת ה-ID הישיר של ה-Credentials מ-Jenkins
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        def dockerImage = docker.image("${IMAGE_NAME}:${BUILD_NUMBER}")
                        def dockerImageTagLatest = docker.image("${IMAGE_NAME}:latest")
                        dockerImage.push("${BUILD_NUMBER}")
                        dockerImageTagLatest.push('latest')
                    }
                }
            }
        }

        // שלב 4: פריסה ל-Kubernetes
        stage('Deploy') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }
}
