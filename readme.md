# Summary

Подготовка dev Jenkins инстанса для тестирования ошибка возникающей при запуске ansible таска локально на ноде, с использованием env мастер ноды.

## Запуск стэнда

Для работы со стэндом понадобятся заранее установленый **docker, docker-compose и GNU make**.

```sh
make
build-sources    Create bare repo from jsl sources
help             get help
jenkins-attach   atta into jenkins master
jenkins-build    Build jenkins image
jenkins-down     Rm jenkins image
jenkins-start    Start docker container
jenkins-up       Up container
see-logs         Start docker container
```

- сначала нам требуется собрать и поднять окружение. Для этого испольщуем команду make jenkins-up. После чего будет поднят инстанс Jenkins на порту 8085
- далее логинимся под пользователем test:test и пытаемся запустить джоб **example_run_job**
- После успешной отработки билда можно увидеть ошибку.

Для упращение используется стэнд только с мастер нодой. Но точно такое же поведение будет и при использовании jenkins-slave + docker.inside()

## Configuration files

### shared-library

Данный каталог содержит в себе файлы Jenkins Shared Library и ресурсы предназначеные для тестирования кейса.

### casc

Данный каталог содержит **yml** конфигурацию текущего инстанса Jenkins:

- jenkins.yml - основные настройки инстанса, включающие в себя базовых пользователей и настройку их прав
- JSL.yaml - настройка подключенния Jenkins Shared Library для возможности проверки ошбки с env у ansible
- pipelines.yml - содержит в себе пайплайн необходимый для тестирования функциональности.
