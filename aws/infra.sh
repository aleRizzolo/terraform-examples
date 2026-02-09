#!/bin/bash

set -e

CHOICE=0
ANSWER=""

apply_configuration() {
  echo "Initializing Terraform"
  terraform init

  echo "Validating the configuration"
  terraform validate

  echo "Planning the configuration"
  terraform plan -out my-app.plan

  read -p "Do you want to apply the configuration? [y/yes]: " ANSWER

  if [[ $ANSWER = "y" || $ANSWER = "yes" ]]; then
    echo "Applying the configuration"
    terraform apply my-app.plan
  else
    echo "Exiting"
    exit 0
  fi
}

destroy_configuration() {
  local DESTROY_ANSWER=""
  echo "WARNING: this will delete the infrastructure. The action is not reversible"
  read -p "Proceed? [yes/no]: " DESTROY_ANSWER

  if [[ $DESTROY_ANSWER = "yes" ]]; then
  echo "Destroying"
    terraform destroy --auto-approve
  else
    echo "Exiting"
    exit 0
  fi
}

while true
do
  echo "Press 1 to create the infrastructure"
  echo "Press 2 to delete the infrastructure"
  echo "Press 0 to create the infrastructure"
  read -p "Your choice: " CHOICE

  if [[ $CHOICE -eq 1 ]]; then
    apply_configuration
  elif [[ $CHOICE -eq 2 ]]; then
    destroy_configuration
  elif [[ $CHOICE -eq 0 ]]; then
    exit 0
  fi
done