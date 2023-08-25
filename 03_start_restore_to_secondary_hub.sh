#!/bin/bash
source ./install_lab_python_venv/bin/activate
ansible-playbook ./playbooks/start_restore_to_secondary_hub.yml -v --extra-vars=@00_lab_configuration_variables.yml 