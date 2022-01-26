.DEFAULT_GOAL := help
VPATH = .build

.PHONY:
SHELL=/bin/bash
SHELLOPTS:=$(if $(SHELLOPTS),$(SHELLOPTS):)pipefail:errexit

DOCKER_BUILDKIT=1
COMPOSE_DOCKER_CLI_BUILD=1

#Set vars
CUR_DIR := $(shell pwd)
PATH := ${HOME}/.local/bin/:${PATH}
HOSTNAME := $(shell hostname)
CURRENT_DEV_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
SLAVE_WORKDIR := $(shell echo ${CUR_DIR}/slave)
GIT_USER := $(shell git config --global user.name)
CURRENT_USER := $(shell whoami)
EXTERNAL_USER := $(shell id -u):$(shell id -g)
BASE_IMAGE=$(shell grep -ioP '(?<=^from)\s+\S+' Dockerfile | head -n 1 | cut -d ' ' -f 2)
AGENT_BASE_IMAGE=$(shell grep -ioP '(?<=^from)\s+\S+' dind_agent/Dockerfile | head -n 1 | cut -d ' ' -f 2)

export



#Print help message
help: ## get help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: clean-shared-library
clean-shared-library:
	@[[ -d ".build/shared-library.git" ]] && rm -rf .build/shared-library.git || echo 'Not found jsl dir'

.PHONY: jenkins-build
jenkins-build: build-sources ## Build jenkins image
	docker-compose -f ${JENKINS_DOCKER_FOLDER}./docker-compose.yaml build

.PHONY: jenkins-down
jenkins-down: ## Rm jenkins image
	docker-compose -f ${JENKINS_DOCKER_FOLDER}./docker-compose.yaml down -v

.PHONY: jenkins-up
jenkins-up: jenkins-build  ## Up container 
	docker-compose -f ${JENKINS_DOCKER_FOLDER}./docker-compose.yaml up -d

.PHONY: jenkins-stop  ## Stop docker container
jenkins-stop:
	docker-compose -f ${JENKINS_DOCKER_FOLDER}./docker-compose.yaml stop

.PHONY: jenkins-attach
jenkins-attach:  ## atta into jenkins master
	docker-compose -f ${JENKINS_DOCKER_FOLDER}./docker-compose.yaml exec jenkins-dev-server /bin/bash

.PHONY: jenkins-start
jenkins-start:	## Start docker container
	docker-compose -f ${JENKINS_DOCKER_FOLDER}./docker-compose.yaml start

.PHONY: see-logs
see-logs:	## Start docker container
	docker-compose -f ${JENKINS_DOCKER_FOLDER}./docker-compose.yaml logs

build-sources: clean-shared-library ## Create bare repo from jsl sources
	@mkdir .build/shared-library.git && cd .build/shared-library.git && git init && \
		cp -R ../../shared-library/. ./ && \
		git add .  && \
        git commit -m 'Initial commit'