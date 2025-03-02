#!/bin/bash

source ./common_vars.sh

echo "Testing autoscaling for instance group $INSTANCE_GROUP_NAME"

# Function to get the current number of instances
get_instance_count() {
    gcloud compute instance-groups managed list-instances $INSTANCE_GROUP_NAME \
        --project=$PROJECT_ID \
        --zone=$ZONE \
        --format="value(instance)" | wc -l
}

# Function to simulate high CPU load
simulate_high_cpu_load() {
    local instance=$1
    echo "Simulating high CPU load on $instance"
    gcloud compute ssh $instance --project=$PROJECT_ID --zone=$ZONE --command="sudo apt-get update && sudo apt-get install -y stress-ng && stress-ng --cpu 4 --timeout 300s" &
}

echo "Initial instance count: $(get_instance_count)"

# Get list of instances
instances=$(gcloud compute instance-groups managed list-instances $INSTANCE_GROUP_NAME \
    --project=$PROJECT_ID \
    --zone=$ZONE \
    --format="value(instance.basename())")

echo "Instances in the group:"
echo "$instances"

# Simulate high CPU load on all instances
for instance in $instances; do
    simulate_high_cpu_load $instance
done

echo "Waiting for autoscaling to react (5 minutes)..."
sleep 300

echo "Final instance count: $(get_instance_count)"

echo "Autoscaling test completed. Check the GCP Console for detailed metrics and scaling events."
