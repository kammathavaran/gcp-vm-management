# gcp-vm-management

Prerequisites 
1. Install gcloud cli on your laptop 
2. configure gcloud to connect to your account and the right zone. 

Steps

1. Configure your project name and other details in the common_vars.sh file
2. create-resources is a simple shell script which will create all the resources required for the test. 
3. test-autoscaling will attempt to install stress-ng on the VMS and run a stress test on 4 CPUS for 300s. 
4. Configuration can be changes in common_vars or the test-autoscaling script. 
5. cleanup.sh will attempt to destroy the resources created for another test. 


