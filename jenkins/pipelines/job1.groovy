def job1() {
    def core = load "${env.WORKSPACE}/jenkins/lib/core.groovy"

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