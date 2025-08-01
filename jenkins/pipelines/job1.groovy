def job1() {
    def core = load "jenkins/libs/core.groovy"

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