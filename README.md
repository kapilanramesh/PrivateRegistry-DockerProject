# Docker Project with Custom Registry + CI/CD + Vulnerability Scanning


README based on the structure we discussed:

---

# Docker Project with Custom Registry + CI/CD + Vulnerability Scanning

## Project Overview

This project demonstrates how to set up a **custom Docker registry**, integrate a **CI/CD pipeline using Jenkins**, and perform **vulnerability scanning** on Docker images using **Trivy**.

### Key Components:

- **Custom Docker Registry**: A local registry to push and store Docker images.
    
- **CI/CD Pipeline**: Jenkins pipeline automating the build, scan, and push process.
    
- **Trivy**: A tool for scanning Docker images for vulnerabilities.
    
- **NGINX Basic Auth**: Adds basic authentication to the registry for security.
    

## Architecture Diagram

(Insert diagram here)

### Key Architecture Components:

- **Jenkins**: Handles the CI/CD pipeline.
    
- **Docker Registry**: Stores Docker images.
    
- **Trivy**: Performs vulnerability scanning.
    
- **NGINX**: Adds basic authentication to the registry.
    

## 1. Registry Setup

### NGINX Basic Auth Setup

1. **Install NGINX**: Make sure NGINX is installed on the server that will host your Docker registry.
    
    ```bash
    sudo apt update && sudo apt install -y nginx
    ```
    
2. **Create a password file for basic auth**:
    
    Use the `htpasswd` command to create a user and password for basic authentication.
    
    ```bash
    sudo apt-get install apache2-utils
    sudo htpasswd -c /etc/nginx/.htpasswd myuser
    ```
    
3. **Configure NGINX**:
    
    Edit the NGINX configuration file (`/etc/nginx/sites-available/default`) to add basic authentication to your Docker registry.
    
    Example:
    
    ```nginx
    server {
        listen 80;
        server_name localhost;
    
        location /v2/ {
            auth_basic "Restricted Access";
            auth_basic_user_file /etc/nginx/.htpasswd;
    
            proxy_pass http://localhost:5000;
        }
    }
    ```
    
4. **Restart NGINX**:
    
    After configuring NGINX, restart the service.
    
    ```bash
    sudo systemctl restart nginx
    ```
    
5. **Test the authentication**:
    
    Try accessing the registry URL (`http://localhost:5000`) in a browser or through a `curl` command. You should be prompted for the username and password you created.
    

### Local Docker Registry Config

1. **Run the Docker Registry**:

    Start a Docker registry on your local machine with NGINX basic authentication.
    
    ```bash
    docker run -d -p 5000:5000 --name registry registry:2
    ```
    
    The Docker registry will be accessible on `localhost:5000`.

2. **Configure Docker to use the local registry**:

    To push and pull images, you’ll need to configure Docker to trust the registry.
    
    Add the following to `/etc/docker/daemon.json`:
    
    ```json
    {
        "insecure-registries" : ["localhost:5000"]
    }
    ```
    
    Then restart Docker:
    
    ```bash
    sudo systemctl restart docker
    ```
    

## 2. CI/CD Pipeline

### Jenkinsfile Breakdown

This Jenkinsfile is used to automate the build, scan, and push process for Docker images.

1. **Build Docker Image**:

	
    - The pipeline builds a Docker image from a local `Dockerfile`.
        
    - The image is tagged and pushed to the local Docker registry.
        
2. **Trivy Vulnerability Scan**:

	
    - Trivy scans the built Docker image for high and critical vulnerabilities.
        
    - The report is saved as a `.txt` file for archiving.
        
3. **Push to Local Registry**:

    - After scanning, the image is pushed to the local Docker registry.
        
4. **Archive Artifacts**:

    - The Trivy report file is archived as an artifact for further review.
        

### Trivy Usage

- **Trivy Command**:
    
    In the Jenkins pipeline, Trivy is run with the following command to scan for **high** and **critical** vulnerabilities in the Docker image:
    
    ```bash
    trivy image --severity HIGH,CRITICAL --format table --output trivy-report-5.txt localhost:5000/myapp:5
    ```
    

### Docker Build + Push

1. **Build Docker Image**: Jenkins uses the `docker build` command to create an image from the Dockerfile.
    
    Example:
    
    ```bash
    docker build -t localhost:5000/myapp:5 .
    ```
    
2. **Push Docker Image**: The image is then pushed to the local registry.
    
    Example:
    
    ```bash
    docker push localhost:5000/myapp:5
    ```
    

## Usage Instructions

1. **Clone the Repository**:


    ```bash
    git clone https://github.com/kapilanramesh/docker-project.git
    cd docker-project
    ```
    
2. **Run the Jenkins Pipeline**:


    - Ensure that Jenkins is set up and running.
        
    - Create a new Jenkins job and configure it to use the `Jenkinsfile` from this repository.
        
    - Trigger the pipeline to start building and pushing the Docker image.
        
3. **Access the Local Registry**:


    - After the image is built and pushed, you can access it by pulling from `localhost:5000/myapp:5`.
        
    
    ```bash
    docker pull localhost:5000/myapp:5
    ```
    
4. **View Trivy Report**:


    - The Trivy report is available as an archived artifact in Jenkins.
        
    - You can review the vulnerabilities that were detected during the scan.
        

## Sample Output / Screenshot

(Insert sample output or screenshot here)

---

### Optional: GitHub Actions Equivalent

You can also set up a similar CI/CD pipeline using GitHub Actions. Below is an example `workflow.yml` file to perform similar tasks.

```yaml
name: Docker Build, Scan, and Push

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v1
    - name: Build Docker Image
      run: docker build -t localhost:5000/myapp:5 .
    - name: Scan Docker Image with Trivy
      run: trivy image --severity HIGH,CRITICAL --format table --output trivy-report-5.txt localhost:5000/myapp:5
    - name: Push Docker Image to Registry
      run: docker push localhost:5000/myapp:5
    - name: Upload Trivy Report
      uses: actions/upload-artifact@v2
      with:
        name: trivy-report
        path: trivy-report-5.txt
```

---

