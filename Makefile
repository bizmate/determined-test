# Define required macros here
SHELL := /usr/bin/env bash
PROJECT_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))
COMPOSER_HOME := $$HOME/.config/composer
COMPOSER_CACHE_DIR := $$HOME/.cache/composer

check_uid_and_env_vars:
	if [ -z "$(UID)" ]; then echo "UID variable required, please run 'export UID' before running make task"; exit 1 ; fi

up: check_uid_and_env_vars up_nobuild

up_nobuild: check_uid_and_env_vars
	export UID && docker-compose up -d --force-recreate --remove-orphans
	bin/wait_for_docker.bash "DB migrations completed"
	bin/wait_for_docker.bash "accepting incoming connections on port 8080"

bash_master: check_uid_and_env_vars
	export UID && docker-compose exec determined-master bash

bash_agent: check_uid_and_env_vars
	export UID && docker-compose exec determined-agent bash

down:
	docker-compose down

logs_tail:
	if [ -z "$(UID)" ]; then echo "UID variable required, please run 'export UID' before running make task"; exit 1 ; fi
	export UID && docker-compose logs -f
