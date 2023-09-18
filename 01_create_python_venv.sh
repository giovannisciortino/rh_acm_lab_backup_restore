#!/bin/bash
rm -rf ./python_venv
python3 -m venv python_venv
source ./python_venv/bin/activate
pip install -r requirements.txt
