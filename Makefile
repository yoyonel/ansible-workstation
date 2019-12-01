PROJECT_NAME?=ansible-workstation
PROJECT_VERSION:=0.0.1
#
DOCKER_TAG?=yoyonel/$(PROJECT_NAME):${PACKAGE_VERSION}
#
SOURCES=
#
ANSIBLE_HOSTS?=/etc/ansible/hosts
ANSIBLE_PLAYBOOK?=./laptop.yml
ANSIBLE_PLAYBOOK_COMMON=$(shell find roles/common -type f -name '*.yml')
ANSIBLE_TAGS?="*"
ANSIBLE_PLAYBOOK_OPTIONS?=

all: help

# https://github.com/AnyBlok/anyblok-book-examples/blob/III-06_polymorphism/Makefile
define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT
help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)


create-users:	## ansible playbook for creating user: "latty"
	ansible-playbook \
		create-users.yml \
		--ask-vault-pass \
		--extra-vars "inventory=all" \
		-i ${ANSIBLE_HOSTS}

${ANSIBLE_PLAYBOOK_COMMON}: common

ansible-playbook:
	ansible-playbook \
		-i ${ANSIBLE_HOSTS} \
		--tags ${ANSIBLE_TAGS} \
		${ANSIBLE_PLAYBOOK_OPTIONS} \
		${ANSIBLE_PLAYBOOK}

common:	## ansible playbook for installing: common packages (apt, snap)
	ANSIBLE_TAGS="common" \
	make ansible-playbook

shell:	## ansible playbook for installing: shell (zsh + antigen + powerline9k)
	ANSIBLE_TAGS="shell" \
	make ansible-playbook

docker: ## ansible playbook for installing: docker (docker, docker-compose)
	ANSIBLE_TAGS="docker" \
	make ansible-playbook

tmux: ## ansible playbook for installing: TMux
	ANSIBLE_TAGS="tmux" \
	make ansible-playbook	

python-pyenv: ## ansible playbook for installing: Python (pyenv)
	ANSIBLE_TAGS="pyenv" \
	make ansible-playbook

python: python-pyenv

ide-pycharm: ## ansible playbook for install: Pycharm (IDE)
	ANSIBLE_TAGS="pycharm" \
	make ansible-playbook

ide-pycharm-plugins: ## ansible playbook for install: Pycharm (IDE)
	ANSIBLE_TAGS="pycharm-plugins" \
	make ansible-playbook

ide-vscode: ## ansible playbook for install: Visual Studio Code (IDE)
	ANSIBLE_TAGS="vscode" \
	make ansible-playbook

ide: ide-pycharm ide-pycharm-plugins

default: help
