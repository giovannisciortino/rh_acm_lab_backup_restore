#!/bin/bash
source ./python_venv/bin/activate
ansible-playbook ./playbooks/install_acm.yml --extra-vars=@00_acm_configuration_variables.yml -v