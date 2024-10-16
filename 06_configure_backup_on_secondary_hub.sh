#!/bin/bash
source ./python_venv/bin/activate
ansible-playbook ./playbooks/configure_backup_on_secondary_hub.yml -v --extra-vars=@02_acm_configuration_variables.yml
