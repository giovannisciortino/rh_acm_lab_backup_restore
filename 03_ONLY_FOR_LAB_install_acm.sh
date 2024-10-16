#!/bin/bash
source ./python_venv/bin/activate
ansible-playbook ./playbooks/install_acm.yml --extra-vars=@02_acm_configuration_variables.yml -v