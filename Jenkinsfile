pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'rosscameron7/coursework2'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_ID} ."
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    def containerId = sh(script: "docker run -d ${DOCKER_IMAGE_NAME}:${BUILD_ID} sleep 5", returnStdout: true).trim()
                    def exitCode = sh(script: "docker wait ${containerId}", returnStatus: true)

                    if (exitCode == 0) {
                        echo "Container launched successfully."
                    } else {
                        error "Container launch failed."
                    }
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    // Push the Docker image to DockerHub
                    withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                        sh "docker push ${DOCKER_IMAGE_NAME}:${BUILD_ID}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes nodes') {
             steps {
                script {
                    sshagent(['my-ssh-key']) {
                 sh "ssh ubuntu@54.205.117.197 'kubectl get deployments && kubectl set image deployments/coursework2 coursework2=${DOCKER_IMAGE_NAME}:${BUILD_ID}'"
                    }
                }
            }
        }
    }
}
