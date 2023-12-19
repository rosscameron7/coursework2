pipeline {
    agent any

    stages {
        stage('Building Docker Image') {
            steps {
                script {
                    sh "docker build -t rosscameron7/coursework2:${BUILD_ID} ."
                }
            }
        }

        stage('Image Test') {
            steps {
                script {
                    def containerId = sh(script: "docker run -d rosscameron7/coursework2:${BUILD_ID} sleep 5", returnStdout: true).trim()
                    def exitCode = sh(script: "docker wait ${containerId}", returnStatus: true)
                    if (exitCode == 0) {
                        echo "The container has been launched successfully."
                    } else {
                        error "The container launch has failed."
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'Dockerhub', variable: 'DOCKER_PASSWORD')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login --username rosscameron7 --password-stdin"
                        sh "docker build -t rosscameron7/coursework2:${BUILD_ID} ."
                        sh "docker push rosscameron7/coursework2:${BUILD_ID}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes nodes') {
            steps {
                script {
                    sshagent(credentials: ['my-ssh-key']) {
                        sh "ssh ubuntu@54.205.117.197 'kubectl get deployments && kubectl set image deployments/coursework2-deployment coursework2-deployment=rosscameron7/coursework2:${BUILD_ID} --namespace=default'"
                    }
                }
            }
        }
    }
}
