def job1(context) {
    def core = load('jenkins/libs/core.groovy')

    core.build(context)
    core.sonarqube(context)
}

return this