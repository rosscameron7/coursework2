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
                        def podName = sh(script: "kubectl get pods --selector=app=coursework2-deployment -o jsonpath='{.items[0].metadata.name}' --namespace=default", returnStdout: true).trim()
                        sh "kubectl set image pod/${podName} coursework2-deployment=rosscameron7/coursework2:${BUILD_ID} --namespace=default"
                    }
                }
            }
        }
    }
}
