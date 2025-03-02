source ./common_vars.sh

gcloud compute instance-groups managed delete $INSTANCE_GROUP_NAME --zone=$ZONE
gcloud compute instance-templates delete $INSTANCE_TEMPLATE_NAME
gcloud compute firewall-rules delete allow-http-https

