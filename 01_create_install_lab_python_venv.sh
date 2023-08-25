#!/bin/bash
rm -rf ./install_lab_python_venv
python3 -m venv install_lab_python_venv
source ./install_lab_python_venv/bin/activate
pip install -r requirements.txt