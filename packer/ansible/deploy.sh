#!/bin/bash
ansible-playbook -i ./inventories/${1:-dev} ${2:-site}.yaml -e env=${1:-dev}