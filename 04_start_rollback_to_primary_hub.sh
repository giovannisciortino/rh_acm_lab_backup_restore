#!/bin/bash
source ./install_lab_python_venv/bin/activate
ansible-playbook ./playbooks/start_rollback_to_primary_hub.yml -v --extra-vars=@00_lab_configuration_variables.yml 