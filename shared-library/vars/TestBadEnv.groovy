void call(){
    String playbook = libraryResource('test-playbook.yml')
    String ansibleCfg = libraryResource('ansible.cfg')
    String filterEnv = libraryResource('filter_env.py')
    node('master'){
        echo "Run testing scripts to check bad env variable"
        sh 'printenv'
        dir('callback_plugins'){
            writeFile(file: 'filter_env.py', text: filterEnv)
        }
        writeFile(file: 'playbook.yml', text: playbook)
        writeFile(file: 'ansible.cfg', text: ansibleCfg)
        sh 'PATH="${PATH}:${JENKINS_HOME}/.local/bin" ansible-playbook playbook.yml -i localhost, -vvvv'
    }
}
