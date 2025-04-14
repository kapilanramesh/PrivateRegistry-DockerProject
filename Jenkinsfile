pipeline {
    agent any

    environment {
        IMAGE_NAME = "myapp"
        IMAGE_TAG = "${env.BUILD_ID}"
        LOCAL_REGISTRY = "localhost:5000"
        FULL_IMAGE_NAME = "${LOCAL_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
        SCAN_REPORT = "trivy-report-${IMAGE_TAG}.txt"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${FULL_IMAGE_NAME} ."
                }
            }
        }

        stage('Trivy Vulnerability Scan') {
            steps {
                script {
                    sh "trivy image --severity HIGH,CRITICAL --format table --output ${SCAN_REPORT} ${FULL_IMAGE_NAME}"
                }
            }
        }

        stage('Push to Local Registry') {
            steps {
                script {
                    sh "docker push ${FULL_IMAGE_NAME}"
                }
            }
        }

        stage('Archive Scan Report') {
            steps {
                archiveArtifacts artifacts: "${SCAN_REPORT}", fingerprint: true
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
