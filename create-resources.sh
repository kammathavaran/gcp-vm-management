#!/bin/bash

source ./common_vars.sh

echo "Starting GCP VM setup with auto-scaling and security configurations..."

# Create VM Instance
create_vm() {
    echo "Creating VM instance..."
    gcloud compute instances create $VM_NAME \
        --project=$PROJECT_ID \
        --zone=$ZONE \
        --machine-type=$MACHINE_TYPE \
        --image-family=$IMAGE_FAMILY \
        --image-project=$IMAGE_PROJECT \
        --tags=http-server,https-server
    echo "VM instance $VM_NAME created successfully."
    
}

# Create Instance Template
create_instance_template() {
    echo "Creating instance template..."
    gcloud compute instance-templates create $INSTANCE_TEMPLATE_NAME \
        --project=$PROJECT_ID \
        --machine-type=$MACHINE_TYPE \
        --image-family=$IMAGE_FAMILY \
        --image-project=$IMAGE_PROJECT \
        --tags=http-server,https-server
        --metadata=startup-script='sudo apt-get update && sudo apt-get install -y stress-ng'

    echo "Instance template $INSTANCE_TEMPLATE_NAME created successfully."

}

# Create Managed Instance Group
create_instance_group() {
    echo "Creating managed instance group..."
    gcloud compute instance-groups managed create $INSTANCE_GROUP_NAME \
        --project=$PROJECT_ID \
        --zone=$ZONE \
        --template=$INSTANCE_TEMPLATE_NAME \
        --size=$MIN_INSTANCES

    gcloud compute instance-groups managed set-autoscaling $INSTANCE_GROUP_NAME \
        --project=$PROJECT_ID \
        --zone=$ZONE \
        --min-num-replicas=$MIN_INSTANCES \
        --max-num-replicas=$MAX_INSTANCES \
        --target-cpu-utilization=$CPU_UTILIZATION_TARGET
    echo "Managed instance group $INSTANCE_GROUP_NAME created with autoscaling."
}

# Configure Firewall Rules
configure_firewall() {
    echo "Configuring firewall rules..."
    gcloud compute firewall-rules create $FIREWALL_RULE_NAME \
        --project=$PROJECT_ID \
        --direction=INGRESS \
        --priority=1000 \
        --network=default \
        --action=ALLOW \
        --rules=tcp:80,tcp:443 \
        --source-ranges=0.0.0.0/0 \
        --target-tags=http-server,https-server
    echo "Firewall rule $FIREWALL_RULE_NAME created successfully."
}

# Configure IAM Roles
configure_iam() {
    echo "Configuring IAM roles..."
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member=$USER_OR_SERVICE_ACCOUNT \
        --role=roles/compute.admin
    echo "IAM role 'Compute Admin' granted to $USER_OR_SERVICE_ACCOUNT."
}

# Run all functions
# create_vm
create_instance_template
create_instance_group
configure_firewall
configure_iam

echo "Setup completed successfully!"
