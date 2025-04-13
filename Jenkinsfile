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
                    // Build the Docker image
                    docker.build("${IMAGE_NAME}", ".")
                }
            }
        }
        stage('Scan for vulnerabilities') {
            steps {
                script {
                    // Scan the image with Trivy
                    sh "trivy image ${REGISTRY}/${IMAGE_NAME}"
                }
            }
        }
        stage('Push to Registry') {
            steps {
                script {
                    // Tag and push the Docker image to the registry
                    docker.tag("${IMAGE_NAME}", "${REGISTRY}/${IMAGE_NAME}:latest")
                    docker.push("${REGISTRY}/${IMAGE_NAME}:latest")
                }
            }
        }
    }
}
