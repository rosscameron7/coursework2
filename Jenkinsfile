pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = 'rosscameron/coursework2'
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
                        echo "The container has been launched successfully."
                    } else {
                        error "The countainer launch has failed."
                    }
                }
            }
        }
    }
}
