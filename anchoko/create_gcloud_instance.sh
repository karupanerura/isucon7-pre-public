#!/bin/sh

INSTANCE_NAME=$1
echo "Create Instance: $INSTANCE_NAME"

gcloud compute disks create $INSTANCE_NAME --size "20" --source-snapshot "isucon7-pre-base" --type "pd-standard"

gcloud beta compute instances create $INSTANCE_NAME --machine-type "n1-standard-2" --subnet "default" --maintenance-policy "MIGRATE" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --min-cpu-platform "Automatic" --disk "name=$INSTANCE_NAME,device-name=$INSTANCE_NAME,mode=rw,boot=yes,auto-delete=yes"

