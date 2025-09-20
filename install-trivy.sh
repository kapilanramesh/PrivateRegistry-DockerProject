#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🚀 Starting Trivy installation via APT method..."

# Install prerequisites
echo "Installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y wget apt-transport-https gnupg lsb-release curl

# Add Aqua Security's public GPG key
echo "Adding Aqua Security's public GPG key..."
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -

# Add Trivy APT repository for your distro
echo "Adding Trivy APT repository..."
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list

# Update package list to include Trivy repo
echo "Updating package list..."
sudo apt-get update -y

# Install Trivy
echo "Installing Trivy..."
sudo apt-get install -y trivy

# Verify installation
echo "Verifying Trivy installation..."
trivy --version

echo "✅ Trivy installation completed successfully!"
