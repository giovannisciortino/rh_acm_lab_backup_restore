#!/bin/bash
source ./python_venv/bin/activate
ansible-playbook ./playbooks/start_restore_to_secondary_hub.yml -v --extra-vars=@02_acm_configuration_variables.yml
