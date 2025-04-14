pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'localhost:5000'
        IMAGE_NAME = 'myapp'
        IMAGE_TAG = '5'
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} .'
                }
            }
        }

        stage('Trivy Vulnerability Scan') {
            steps {
                script {
                    sh "trivy image --severity HIGH,CRITICAL --format table --output trivy-report-${IMAGE_TAG}.txt ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Push to Local Registry') {
            steps {
                script {
                    sh "docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Archive Scan Report') {
            steps {
                script {
                    // Ensure the file exists before archiving
                    def reportFile = "trivy-report-${IMAGE_TAG}.txt"
                    if (fileExists(reportFile)) {
                        archiveArtifacts allowEmptyArchive: true, artifacts: reportFile, followSymlinks: false
                    } else {
                        echo "Trivy report file not found: ${reportFile}"
                    }
                }
            }
        }
    }

    post {
        always {
            // Ensure the file exists before archiving
            script {
                def reportFile = "trivy-report-${IMAGE_TAG}.txt"
                if (fileExists(reportFile)) {
                    archiveArtifacts allowEmptyArchive: true, artifacts: reportFile, followSymlinks: false
                } else {
                    echo "Trivy report file not found: ${reportFile}"
                }
            }
        }
    }
}
