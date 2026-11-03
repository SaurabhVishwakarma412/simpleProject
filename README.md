
# Static HTML DevOps Deployment Project

## Project Overview

This project demonstrates automated deployment
of a static HTML website using:

- HTML
- Docker
- Nginx
- Git and GitHub
- Jenkins
- Docker Hub
- AWS EC2

## Project Structure

static-html-devops/
    index.html
    Dockerfile
    .dockerignore
    Jenkinsfile
    README.md

## Run Locally

Build Docker image:

docker build -t static-html-demo .

Run Docker container:

docker run -d -p 8080:80 \
--name my-website static-html-demo

Open:

http://localhost:8080

## CI/CD Pipeline

1. Developer pushes code to GitHub.
2. Jenkins checks out the repository.
3. Jenkins builds Docker image.
4. Jenkins pushes image to Docker Hub.
5. Jenkins connects to AWS EC2.
6. EC2 pulls the latest image.
7. Docker starts the website container.

## AWS Deployment

Open the website using:

http://YOUR_EC2_PUBLIC_IP

## Jenkins Credentials

Docker Hub:
dockerhub-creds

AWS SSH:
ec2-ssh-key
