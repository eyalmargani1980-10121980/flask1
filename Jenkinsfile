pipeline {
    agent any

    environment {
        // המזהה של ההרשאות שהגדרת ב-Jenkins תחת Manage Credentials
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        
        // שם המשתמש שלך ב-DockerHub ושם ה-Repository
        IMAGE_NAME = 'EYALMARGANI1980/flask-hello-world'
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
                    dockerImage = docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                    dockerImageTagLatest = docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        // שלב 3: העלאת האימג' ל-DockerHub
        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'DOCKERHUB_CREDENTIALS') {
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
