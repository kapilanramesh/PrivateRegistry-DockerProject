---

# Jenkins CI/CD Pipeline with Local Docker Registry & Trivy Vulnerability Scanning

This Jenkins pipeline automates the process of building a Docker image, scanning it for vulnerabilities using **Trivy**, and pushing it to a **local Docker registry**. The pipeline ensures that the local registry is running and archives the scan report for future reference.

---

## Features

1. **Automated Docker image build**

   * Builds a Docker image from the repository’s `Dockerfile`.

2. **Secure Trivy installation**

   * Checks if Trivy is installed; if not, installs it using the **APT method** with repository and GPG key verification.
   * Ensures authenticity of the Trivy package.

3. **Vulnerability scanning**

   * Scans the Docker image for **HIGH** and **CRITICAL** vulnerabilities.
   * Saves the report in a text file and archives it as a Jenkins artifact.

4. **Local Docker registry management**

   * Ensures a **local registry** is running on port `5000`.
   * Automatically starts the registry if it is not running.

5. **Push Docker image to local registry**

   * Tags and pushes the image to `localhost:5000`.

6. **Artifact management**

   * Archives Trivy scan reports for easy access after each build.

---

## Pipeline Overview

### Environment Variables

| Variable                  | Description                                              |
| ------------------------- | -------------------------------------------------------- |
| `DOCKER_REGISTRY`         | Address of the local Docker registry (`localhost:5000`). |
| `IMAGE_NAME`              | Name of the Docker image to build (`myapp`).             |
| `IMAGE_TAG`               | Version tag of the Docker image (`5`).                   |
| `REGISTRY_CONTAINER_NAME` | Name of the local registry container (`local-registry`). |

### Stages

1. **Checkout SCM**

   * Pulls the latest code from the source control repository.

2. **Install Trivy**

   * Checks if Trivy is installed.
   * If missing, installs it using the **APT repository method**:

     * Installs prerequisites: `wget`, `apt-transport-https`, `gnupg`, `lsb-release`.
     * Downloads and adds Aqua Security’s **public GPG key**.
     * Adds Trivy’s **APT repository** for the system’s Linux distribution.
     * Updates package lists and installs Trivy.
     * Verifies installation with `trivy --version`.

3. **Build Docker Image**

   * Builds the Docker image using the repository’s `Dockerfile`.
   * Tags the image as `${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}`.

4. **Trivy Vulnerability Scan**

   * Scans the built Docker image for **HIGH** and **CRITICAL** vulnerabilities.
   * Saves the scan report as `trivy-report-${IMAGE_TAG}.txt`.

5. **Ensure Local Registry Running**

   * Checks if a container with name `${REGISTRY_CONTAINER_NAME}` is running.
   * If not, starts a new registry container in **detached mode** (`-d`) with `--restart=always` on port 5000.

6. **Push to Local Registry**

   * Pushes the Docker image to the local registry at `localhost:5000`.

7. **Archive Scan Report**

   * Archives the Trivy scan report as a Jenkins artifact.

---

### Post Actions

* Always archives the Trivy scan report, even if the pipeline fails or aborts.

---

## Prerequisites

1. Jenkins server with **Docker installed** on the agent.
2. EC2 or Linux machine with **sudo access** for installing Trivy.
3. Docker daemon must be running.
4. Optional: Existing local registry container (the pipeline can start it automatically if missing).

---

## Usage

1. Copy the Jenkinsfile into your repository root.
2. Configure a Jenkins pipeline job to point to your repository.
3. Run the pipeline.
4. After execution, you can:

   * View the **Trivy vulnerability report** in the archived artifacts.
   * Access the Docker image in the local registry (`localhost:5000/myapp:5`).

---

## Notes

* The Trivy installation is **secure and verified** using Aqua Security’s public GPG key.
* The local registry is **persistent** due to the `--restart=always` flag.
* This pipeline is fully automated and **idempotent**, meaning it can run multiple times without breaking.

---

Do you want me to make that diagram?
