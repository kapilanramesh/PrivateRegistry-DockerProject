pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'localhost:5000'
        IMAGE_NAME = 'myapp'
        IMAGE_TAG = '5'
        REGISTRY_CONTAINER_NAME = 'local-registry'
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

        stage('Ensure Local Registry Running') {
            steps {
                script {
                    def registryStatus = sh(script: "docker ps --filter 'name=${REGISTRY_CONTAINER_NAME}' --filter 'status=running' --format '{{.Names}}'", returnStdout: true).trim()
                    if (registryStatus == "") {
                        echo "Local registry not running. Starting it now..."
                        sh "docker run -d -p 5000:5000 --restart=always --name ${REGISTRY_CONTAINER_NAME} registry:2"
                    } else {
                        echo "Local Docker registry '${REGISTRY_CONTAINER_NAME}' is already running."
                    }
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
