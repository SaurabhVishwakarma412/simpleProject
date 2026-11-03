pipeline {

    agent any

    environment {

        DOCKERHUB_USER = 'saurabhkv'

        IMAGE_NAME = 'static-html-demo'
    }

    stages {

        stage('Checkout') {

            steps {

                checkout scm

            }
        }

        // Stage 2: Build Docker Image
        stage('Build Docker Image') {

            steps {

                sh '''
                    docker build \
                    -t $DOCKERHUB_USER/$IMAGE_NAME:$BUILD_NUMBER .

                    docker tag \
                    $DOCKERHUB_USER/$IMAGE_NAME:$BUILD_NUMBER \
                    $DOCKERHUB_USER/$IMAGE_NAME:latest
                '''

            }
        }

        // Stage 3: Login to Docker Hub
        stage('Docker Hub Login') {

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
                    '''

                }
            }
        }

        // Stage 4: Push Image to Docker Hub
        stage('Push to Docker Hub') {

            steps {

                sh '''
                    docker push \
                    $DOCKERHUB_USER/$IMAGE_NAME:$BUILD_NUMBER

                    docker push \
                    $DOCKERHUB_USER/$IMAGE_NAME:latest
                '''

            }
        }
    }

    post {

        always {
            sh 'docker logout || true'
        }

        success {
            echo 'Docker image successfully pushed to Docker Hub!'
        }

        failure {
            echo 'Pipeline failed. Check Jenkins console output.'
        }

    }
}