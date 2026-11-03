
pipeline {

    agent any
    environment {
        DOCKERHUB_USER = 'YOUR_DOCKERHUB_USERNAME'
        IMAGE_NAME = 'static-html-demo'
        EC2_HOST = 'YOUR_EC2_PUBLIC_IP'
        EC2_USER = 'ubuntu'
        CONTAINER_NAME = 'static-html-demo'
    }

    stages {
        // Stage 1: Download source code
        stage('Checkout') {

            steps {

                checkout scm

            }
        }

        // Stage 2: Build Docker image
        stage('Build Docker Image') {

            steps {

                sh '''
                    docker build -t $DOCKERHUB_USER/$IMAGE_NAME:$BUILD_NUMBER .
                '''

            }
        }

        // Stage 3: Push image to Docker Hub
        stage('Push to Docker Hub') {

            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DH_USER',
                        passwordVariable: 'DH_TOKEN'
                    )
                ]) {

                    sh '''
                        echo "$DH_TOKEN" | docker login \
                        -u "$DH_USER" --password-stdin

                        docker push \
                        $DOCKERHUB_USER/$IMAGE_NAME:$BUILD_NUMBER

                        docker logout
                    '''

                }
            }
        }

        // Stage 4: Deploy on AWS EC2
        stage('Deploy to AWS EC2') {

            steps {

                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'ec2-ssh-key',
                        keyFileVariable: 'SSH_KEY'
                    )
                ]) {

                    sh '''
                        ssh -o StrictHostKeyChecking=no \
                        -i "$SSH_KEY" \
                        "$EC2_USER@$EC2_HOST" "

                            docker pull \
                            $DOCKERHUB_USER/$IMAGE_NAME:$BUILD_NUMBER &&

                            (docker rm -f $CONTAINER_NAME 2>/dev/null || true) &&

                            docker run -d \
                            --name $CONTAINER_NAME \
                            --restart unless-stopped \
                            -p 80:80 \
                            $DOCKERHUB_USER/$IMAGE_NAME:$BUILD_NUMBER

                        "
                    '''

                }
            }
        }
    }

    post {

        success {
            echo 'Website deployed successfully!'
        }

        failure {
            echo 'Deployment failed. Check Jenkins logs.'
        }

    }
}
