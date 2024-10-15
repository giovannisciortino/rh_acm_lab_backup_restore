#!/bin/bash
source ./python_venv/bin/activate
ansible-playbook ./playbooks/configure_backup_on_secondary_hub.yml -v --extra-vars=@03_acm_configuration_variables.yml
