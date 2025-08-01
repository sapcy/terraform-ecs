def job1() {
    def core = load('jenkins/libs/core.groovy')

    core.build()
    core.sonarqube()
}

return this