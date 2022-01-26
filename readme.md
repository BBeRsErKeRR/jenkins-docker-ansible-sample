# Summary

Дев окружение для работы с Jenkins.

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

## Configuration files

### shared-library

Данный каталог содержит в себе файлы Jenkins Shared Library и ресурсы предназначенные для тестирования кейса.

### casc

Данный каталог содержит **yml** конфигурацию текущего инстанса Jenkins:

- jenkins.yml - основные настройки инстанса, включающие в себя базовых пользователей и настройку их прав
- JSL.yaml - настройка подключения Jenkins Shared Library для возможности проверки ошибки с env у ansible
- pipelines.yml - содержит в себе пайплайн необходимый для тестирования функциональности.
