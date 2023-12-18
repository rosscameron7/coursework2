pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = 'rosscameron/coursework2'
        K8S_DEPLOYMENT_NAME = 'coursework2-deployment'
        K8S_NAMESPACE = 'default'
    }
    stages {
        stage('Building Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_ID} ."
                }
            }
        }
        stage('Image Test') {
            steps {
                script {
                    def containerId = sh(script: "docker run -d ${DOCKER_IMAGE_NAME}:${BUILD_ID} sleep 5", returnStdout: true).trim()
                    def exitCode = sh(script: "docker wait ${containerId}", returnStatus: true)
                    if (exitCode == 0) {
                        echo "The container has been launched successfully."
                    } else {
                        error "The container launch has failed."
                    }
                }
            }
        }
        stage('Pushing Docker Image') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'Dockerhub', variable: 'DOCKER_PASSWORD')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login --username rosscameron7 --password-stdin"
                        sh "docker build -t ${DOCKER_IMAGE_NAME}:${BUILD_ID} ."
                        sh "docker push ${DOCKER_IMAGE_NAME}:${BUILD_ID}"
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "kubectl set image deployment/${K8S_DEPLOYMENT_NAME} ${K8S_DEPLOYMENT_NAME}=${DOCKER_IMAGE_NAME}:${BUILD_ID} --namespace=${K8S_NAMESPACE}"
                }
            }
        }
    }
}
