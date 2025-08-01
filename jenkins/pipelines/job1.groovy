def job1() {
    def core = load "/var/jenkins_home/workspace/테스트1/Job1/jenkins/libs/core.groovy"

    pipeline {
        agent any

        stages {
            stage('build') {
                steps {
                    script {
                        core.build(this)
                    }
                }
            }
        }
    }
}