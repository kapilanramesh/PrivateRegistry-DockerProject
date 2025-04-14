pipeline {
    agent any

    environment {
        IMAGE_NAME = 'myimage'
        REGISTRY = 'localhost:5000'
        IMAGE_TAG = 'latest'
        IMAGE_FULL = "${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
        TRIVY_CONTAINER_ENGINE = 'docker' // 👈 Important fix here
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${IMAGE_FULL} .'
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    sh 'docker push ${IMAGE_FULL}'
                }
            }
        }

        stage('Scan for Vulnerabilities') {
            steps {
                script {
                    sh 'docker pull ${IMAGE_FULL} || echo "Already available"'
                    sh 'trivy image ${IMAGE_FULL}'
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up images..."
            sh 'docker rmi ${IMAGE_FULL} || true'
        }
    }
}
