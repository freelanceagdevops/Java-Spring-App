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
#####################################################################################################
Once you have the pre-requisites, go inside the `app` directory and run the command below:

- `cd app` ===========> Navigate to the app directory
- `mvn clean install` ===========> Build the application

