def job1() {
    def core = load "${env.WORKSPACE}/jenkins/libs/core.groovy"

    pipeline {
        agent any

        stages {
            stage('build') {
                steps {
                    script {
                        sh "${env.WORKSPACE}"
                        core.build(this)
                    }
                }
            }
        }
    }
}