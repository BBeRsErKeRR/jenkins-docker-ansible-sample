void call(){
    String playbook = libraryResource('test-playbook.yml')
    String ansibleCfg = libraryResource('ansible.cfg')
    node('master'){
        echo "Run testing scripts to check bad env variable"
        sh 'printenv'
        writeFile(file: 'playbook.yml', text: playbook)
        writeFile(file: 'ansible.cfg', text: ansibleCfg)
        sh 'PATH="${PATH}:${JENKINS_HOME}/.local/bin" ansible-playbook playbook.yml -i localhost,'
    }
}
