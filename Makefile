.PHONY: help all deps clean
SHELL = /bin/bash

define help

playbook-minecraft-anarchy: Management Makefile
====================================

Available targets:
    help- displays this help text
    clean       - clean up previous runs
    deps- pull in or update all depencencies
    lib - pull in or update Ansible Module Library
    all - wrapper for clean, deps library

endef
export help


# TARGETS

help:
	@echo "$$help"

all:	clean deps lib


deps:
	rm -rf .imported_roles/*
	$(GALAXY) install -r requirements.yml



vag/destroy:
	vagrant destroy -f
vag/up:
	vagrant up

vag/fresh: vag/destroy vag/up

vag/install:
	ansible-playbook -i inventory/vagrant plays/baseline/initial-setup.yml --diff
	ansible-playbook -i inventory/vagrant plays/baseline/packages.yml --diff

vag/spigot:
	ansible-playbook -i inventory/vagrant plays/minecraft/spigot.yml --diff

vag/spigot/configs:
	ansible-playbook -i inventory/vagrant plays/minecraft/spigot.yml --diff --tags configs

vag/spigot/plugins:
	ansible-playbook -i inventory/vagrant plays/minecraft/spigot.yml --diff --tags plugins

vag: vag/up vag/install vag/spigot



prod/install:
	ansible-playbook -i inventory/production plays/baseline/initial-setup.yml --diff
	ansible-playbook -i inventory/production plays/baseline/shorewall.yml  --diff
	ansible-playbook -i inventory/production plays/baseline/packages.yml --diff
	ansible-playbook -i inventory/production plays/baseline/atop.yml  --diff
	ansible-playbook -i inventory/production plays/baseline/ntp.yml  --diff

prod/spigot:
	ansible-playbook -i inventory/production plays/minecraft/spigot.yml --diff

prod/spigot/configs:
	ansible-playbook -i inventory/production plays/minecraft/spigot.yml --diff --tags configs

prod/spigot/plugins:
	ansible-playbook -i inventory/production plays/minecraft/spigot.yml --diff --tags plugins

prod: prod/install prod/spigot
