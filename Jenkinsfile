pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                gitlabCommitStatus('build') {
                    script {
                        docker.withRegistry('https://git.wnuke.dev:5050/wnuke/dockerized-minecraft-client', 'dmc-docker') {
                            def customImage = docker.build("wnuke/dockerized-minecraft-client/dockerized-minecraft-client:${env.BUILD_ID}", "-f ./bot/Dockerfile ./bot/")
                            customImage.push()
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                def msg = "**Status:** " + currentBuild.currentResult.toLowerCase() + "\n"
                msg += "**Changes:** \n"
                if (!currentBuild.changeSets.isEmpty()) {
                    currentBuild.changeSets.first().getLogs().each {
                        msg += "- `" + it.getCommitId().substring(0, 8) + "` *" + it.getComment().substring(0, it.getComment().length()-1) + "*\n"
                    }
                } else {
                    msg += "no changes for this run\n"
                }
                if (msg.length() > 1024) msg.take(msg.length() - 1024)
                withCredentials([string(credentialsId: 'discord-webhook', variable: 'discordWebhook')]) {
                    discordSend thumbnail: "http://wnuke.dev/radiation-symbol.png", successful: currentBuild.resultIsBetterOrEqualTo('SUCCESS'), description: "${msg}", link: env.BUILD_URL, title: "docker-mc-client #${BUILD_NUMBER}", webhookURL: "${discordWebhook}"
                }
            }
        }
    }
}