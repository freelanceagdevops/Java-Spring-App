# Java-Spring-App
This repo is for java based application.

***************** DOCKERIZING SPRINGBOOT APPLICATION *****************

Hello and welcome to this guide on dockerizing sprinboot application. In this guide we will be,

creating a sample springboot application.
Run the application with maven to validate if the application is working.
Create a custom docker image for the application.
Run the docker image to create a springboot application container.
Validate if the application is running on the container.
Before we begin with the above steps, we will be running this application on AWS EC2 instance. So, we will need an EC2 instance running and t2.micro should be sufficient for this guide.

Below are the commands and instructions that you can follow to run this application on EC2 instance.

Head over to https://start.spring.io./ , create a sample application and generate the application which should download the zip file to your local machine. (The same sample application code is available in this repo)


![image](https://github.com/user-attachments/assets/7ce1c8d6-a5f9-4a3a-a66c-a0e59733cebd)


Unzip the contents of the zip file and copy them over to the EC2 instance using the below command.

Install the pre-requisites packages on the EC2 instance using the below commands

Run the following commands one by one to set up the EC2 instance:

- `sudo apt update -y` ===========> Update the machine
- `sudo apt install openjdk-17-jdk -y` ===========> Install Java version 17
- `sudo java -version` ===========> Verify Java installation
- `sudo apt install maven -y` ===========> Install Maven
- `sudo mvn --version` ===========> Verify Maven installation
- `sudo apt install docker.io -y` ===========> Install Docker
- `sudo docker --version` ===========> Verify Docker installation
- `sudo service docker status` ===========> Check Docker service status

- 
#####################################################################################################


Once you have the pre-requisites, go inside the `app` directory and run the command below:

- `cd app` ===========> Navigate to the app directory
- `mvn clean install` ===========> Build the application
- `mvn clean compile` ===========> Clean and Compile the Project
- `mvn spring-boot:run` =========> Run the Application
- `mvn clean package`============> Clean and Compile the Project

#####################################################################################################


Create a Dockerfile and Docker image. Using this Dockerfile, create a container for a Java Spring application.

Docker file :

# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the packaged JAR file into the container
COPY target/your-app.jar /app/your-app.jar

# Run the JAR file
ENTRYPOINT ["java", "-jar", "/app/your-app.jar"]

# Expose the port your app runs on (if needed)
EXPOSE 8080


- `sudo docker image ls`
- `sudo docker build -t spring_app` .
- `sudo docker image ls`
- `sudo docker run -dit -p 80:8080 --name spring_container spring_app`
- `sudo docker ps`


##########################################################################################################

# Access java application 

- `The application will start on port 8080. You can access it by navigating to http://localhost:8080

##########################################################################################################

# CICD Implementation

CICD Implementation: Automate Infrastructure Creation with Terraform & GitHub Actions, and Application Deployment on EKS Cluster
This guide provides a comprehensive walkthrough for setting up a GitOps workflow. It uses Terraform and GitHub Actions to automate infrastructure provisioning on AWS EKS

Step-by-step instructions :

Pre-requisites
- `GitHub account to create repositories`.
- `AWS account with permissions to create EKS resources`.
- `AWS CLI installed and configured on your local machine`.
- `kubectl installed for Kubernetes cluster management`.
###########################################################################################################

Step 1: Create GitHub Repositories
1.1. Create Infrastructure Repository
Create a GitHub repository called infrastructure to store Terraform configurations.
Initialize the repository with a README.md file.
###########################################################################################################

Step 2: Configure GitHub Secrets
2.1. GitHub Secrets Setup
To authenticate GitHub Actions with AWS for infrastructure deployment:

Go to your Infrastructure Repository in GitHub.
Navigate to Settings > Secrets and variables > Actions.
Add the following secrets:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
These secrets are necessary for AWS authentication when GitHub Actions runs the Terraform configuration.

###########################################################################################################

Step 3: Configure Terraform for EKS Setup
3.1. Create Terraform Files
In the Infrastructure Repository, create the following Terraform files:

main.tf (Terraform Configuration for EKS)




