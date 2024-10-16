#!/bin/bash
source ./python_venv/bin/activate
ansible-playbook ./playbooks/configure_backup_on_primary_hub_restore_on_secondary_hub.yml --extra-vars=@02_acm_configuration_variables.yml -v
