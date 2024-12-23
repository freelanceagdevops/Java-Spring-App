## CICD Implementation: Automate Infrastructure Creation with Terraform & GitHub Actions, and Application Deployment on EKS Cluster ##

This guide provides a comprehensive walkthrough for setting up a GitOps workflow. It uses Terraform and GitHub Actions to automate infrastructure provisioning on **AWS EKS**

**Step-by-step instructions**

## Pre-requisites

- **GitHub account** to create repositories.
- **AWS account** with permissions to create EKS resources.
- **AWS CLI** installed and configured on your local machine.
- **kubectl** installed for Kubernetes cluster management.


###########################################################################################################

## Step 1: Create GitHub Repositories

### 1.1. Create Infrastructure Repository
- Create a GitHub repository called **infrastructure** to store Terraform configurations.  
- Initialize the repository with a `README.md` file.

###########################################################################################################

## Step 2: Configure GitHub Secrets

### 2.1. GitHub Secrets Setup
To authenticate GitHub Actions with AWS for infrastructure deployment:

1. Go to your **Infrastructure Repository** in GitHub.
2. Navigate to **Settings > Secrets and variables > Actions**.
3. Add the following secrets:
   - **AWS_ACCESS_KEY_ID**
   - **AWS_SECRET_ACCESS_KEY**

These secrets are necessary for AWS authentication when GitHub Actions runs the Terraform configuration.

###########################################################################################################

## Step 3: Configure Terraform for EKS Setup

### 3.1. Create Terraform Files
In the **Infrastructure Repository**, create the following Terraform files:

### `main.tf` (Terraform Configuration for EKS)

