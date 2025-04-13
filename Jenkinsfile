pipeline {
    agent any
    environment {
        REGISTRY = 'localhost:5000'
        IMAGE_NAME = 'myimage'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}")
                }
            }
        }
        stage('Scan for vulnerabilities') {
            steps {
                script {
                    sh "trivy image ${REGISTRY}/${IMAGE_NAME}"
                }
            }
        }
        stage('Push to Registry') {
            steps {
                script {
                    docker.tag("${IMAGE_NAME}", "${REGISTRY}/${IMAGE_NAME}")
                    docker.push("${REGISTRY}/${IMAGE_NAME}")
                }
            }
        }
    }
}
