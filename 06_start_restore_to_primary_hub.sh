#!/bin/bash
source ./python_venv/bin/activate
ansible-playbook ./playbooks/start_restore_to_primary_hub.yml -v --extra-vars=@00_acm_configuration_variables.yml 