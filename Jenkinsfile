pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                gitlabCommitStatus('build') {
                    script {
                        docker.withRegistry('https://git.wnuke.dev:5050/wnuke/dockerized-minecraft-client', 'dmc-docker') {
                            def customImage = docker.build("dockerized-minecraft-client:${env.BUILD_ID}", "-f ./bot/Dockerfile ./bot/")
                            customImage.push()
                        }
                    }
                }
            }
        }
    }
}