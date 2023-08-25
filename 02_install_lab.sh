#!/bin/bash
source ./install_lab_python_venv/bin/activate
ansible-playbook ./playbooks/install_lab.yml -v --extra-vars=@00_lab_configuration_variables.yml