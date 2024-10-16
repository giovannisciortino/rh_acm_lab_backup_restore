#!/bin/bash
source ./python_venv/bin/activate
ansible-playbook ./playbooks/import_managed_cluster_to_secondary_hub.yml -v --extra-vars=@02_acm_configuration_variables.yml
