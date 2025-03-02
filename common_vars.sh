#!/bin/bash

# GCP Project and Region
export PROJECT_ID="scaling-project-452515"
export REGION="us-central1"
export ZONE="${REGION}-c"

# VM Configuration
export VM_NAME="my-scalable-vm"
export MACHINE_TYPE="e2-medium"
export IMAGE_FAMILY="debian-11"
export IMAGE_PROJECT="debian-cloud"

# Instance Group Configuration
export INSTANCE_TEMPLATE_NAME="a2-template"
export INSTANCE_GROUP_NAME="a2-group"
export MIN_INSTANCES=2
export MAX_INSTANCES=5
export CPU_UTILIZATION_TARGET=0.7

# Firewall Configuration
export FIREWALL_RULE_NAME="allow-http-https"

# IAM Configuration
export USER_OR_SERVICE_ACCOUNT="a2-sa@${PROJECT_ID}.iam.gserviceaccount.com"
