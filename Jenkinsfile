pipeline {
    stages {
        stage('build') {
            steps {
                gitlabCommitStatus('build') {
                    docker.withRegistry('https://git.wnuke.dev/wnuke/dockerized-minecraft-client/dockerized-minecraft-client', 'dmc-gitlab') {
                        def customImage = docker.build("dockerized-minecraft-client:${env.BUILD_ID}", "-f ./bot/Dockerfile .")
                        customImage.push()
                     }
                }
            }
        }
    }
}