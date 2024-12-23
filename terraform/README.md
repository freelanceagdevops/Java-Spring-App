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

Below is the complete Terraform configuration for creating a Virtual Private Cloud (VPC), subnets, routing, and an Amazon Elastic Kubernetes Service (EKS) cluster:

```hcl
# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Create a Route Table and Routes
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "subnet_1_association" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet_2_association" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet_3_association" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.main.id
}

# Define Subnets
resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = true
}

# Configure EKS Cluster using Terraform AWS EKS Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "eks-cluster"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true
  
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.subnet_1.id, 
    aws_subnet.subnet_2.id, 
    aws_subnet.subnet_3.id
  ]

  eks_managed_node_groups = {
    green = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.xlarge"]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }
}


### `provider.tf` (Specifies the AWS Provider)

The `provider.tf` file is used to configure the AWS provider and specify the region for deploying resources. Below is the configuration:

```hcl
# Specify the required provider for AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider with the desired region
provider "aws" {
  region = "ap-south-1"
}


### `backend.tf` (Configure Remote Backend with S3)

The `backend.tf` file configures the backend for storing the Terraform state remotely. In this case, it uses an S3 bucket to store the state file. Below is the configuration:

```hcl
terraform {
  backend "s3" {
    bucket = "java-terraform-s3-bucket"
    key    = "key/terraform.tfstate"
    region = "ap-south-1"
  }
}



### 3.2. Initialize and Validate Infrastructure

After configuring your Terraform files, follow these steps to initialize and validate your infrastructure setup.

1. **Push the Code to Your GitHub Infrastructure Repository**:

   Run the following commands to push your Terraform code to the GitHub repository:

   git add .
   git commit -m "Initial Terraform setup for EKS"
   git push origin main
