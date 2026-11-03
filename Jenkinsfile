
pipeline {

    agent any

    environment {

        DOCKERHUB_USER = 'YOUR_DOCKERHUB_USERNAME'

        IMAGE_NAME = 'static-html-demo'
    }

    stages {

        // Stage 1: Checkout code from GitHub
        stage('Checkout') {

            steps {

                checkout scm

            }
        }

        // Stage 2: Verify Docker
        stage('Check Docker') {

            steps {

                bat '''
                    docker --version
                    docker info
                '''

            }
        }

        // Stage 3: Build Docker Image
        stage('Build Docker Image') {

            steps {

                bat '''
                    docker build -t %DOCKERHUB_USER%/%IMAGE_NAME%:%BUILD_NUMBER% .

                    docker tag %DOCKERHUB_USER%/%IMAGE_NAME%:%BUILD_NUMBER% %DOCKERHUB_USER%/%IMAGE_NAME%:latest
                '''

            }
        }

        // Stage 4: Login to Docker Hub
        stage('Docker Hub Login') {

            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DH_USER',
                        passwordVariable: 'DH_TOKEN'
                    )
                ]) {

                    script {

                        writeFile(
                            file: 'docker-token.txt',
                            text: env.DH_TOKEN
                        )

                        try {

                            bat '''
                                @echo off
                                docker login -u "%DH_USER%" --password-stdin < docker-token.txt
                            '''

                        } finally {

                            bat '''
                                if exist docker-token.txt del /f /q docker-token.txt
                            '''

                        }

                    }

                }

            }
        }

        // Stage 5: Push Image to Docker Hub
        stage('Push to Docker Hub') {

            steps {

                bat '''
                    docker push %DOCKERHUB_USER%/%IMAGE_NAME%:%BUILD_NUMBER%

                    docker push %DOCKERHUB_USER%/%IMAGE_NAME%:latest
                '''

            }
        }
    }

    post {

        always {

            bat 'docker logout'

        }

        success {

            echo 'Docker image successfully pushed to Docker Hub!'

        }

        failure {

            echo 'Pipeline failed. Check Jenkins Console Output.'

        }

    }
}
