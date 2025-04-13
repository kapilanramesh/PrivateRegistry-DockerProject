#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Download and install Trivy to /usr/local/bin
echo "Installing Trivy..."
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Verify installation
echo "Verifying Trivy installation..."
trivy --version

echo "✅ Trivy installation completed successfully."
