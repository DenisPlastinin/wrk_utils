#!/bin/bash
PROJECT_NAME="rstudio-v1"
INSTANCE_NAME="cl-v5"
SSH_USER="ubuntu"
SIZE_DATA_DISK="50"
SERVICE_ACCOUNT=""
TAGS_INSTANCE="http-server,https-server"
LIST_SSH_KEYS="/home/ubuntu/gcp/list_ssh_keys.list"
ZONE="us-central1-a"
REGION="us-central1"
MACHINE_TYPE="f1-micro"
BD_MACHINE_TYPE="db-f1-micro"
ROOT_PASS="123qwe123"

###add ssh_keys form file
/usr/bin/gcloud compute project-info add-metadata --metadata-from-file ssh-keys=$LIST_SSH_KEYS

###create instance in GCP
/usr/bin/gcloud beta compute --project=$PROJECT_NAME instances create $INSTANCE_NAME \
	--zone=$ZONE --machine-type=$MACHINE_TYPE \
	--subnet=default --network-tier=PREMIUM  --maintenance-policy=MIGRATE \
	--tags=$TAGS_INSTANCE --image=ubuntu-1804-bionic-v20190530 --image-project=ubuntu-os-cloud \
	--boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=$INSTANCE_NAME \
	--create-disk=mode=rw,size=$SIZE_DATA_DISK,type=pd-standard,name=data-www-$INSTANCE_NAME,device-name=data-www-$INSTANCE_NAME \
	--async

#/usr/bin/gcloud beta compute --project=$PROJECT_NAME instances create $INSTANCE_NAME --zone=$ZONE --machine-type=$MACHINE_TYPE --subnet=default --network-tier=PREMIUM  --maintenance-policy=MIGRATE --service-account=323289474069-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/cloud-platform --tags=$TAGS_INSTANCE --image=ubuntu-1804-bionic-v20190530 --image-project=ubuntu-os-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=$INSTANCE_NAME --create-disk=mode=rw,size=$SIZE_DATA_DISK,type=projects/rstudio-v1/zones/us-central1-a/diskTypes/pd-standard,name=data-www-$INSTANCE_NAME,device-name=data-www-$INSTANCE_NAME



###create DB instance MySQL
/usr/bin/gcloud beta sql instances create sql-data-$INSTANCE_NAME --tier=$DB_MACHINE_TYPE --region=$REGION --network=default --no-assign-ip --async
###set password for root
/usr/bin/gcloud  sql users set-password root --host=%  --instance=sql-data-$INSTANCE_NAME --password=$ROOT_PASS
EXT_IP_INSTANCE=$(/usr/bin/gcloud compute instances list --filter="NAME:( $INSTANCE_NAME )" | awk '{ print $5}' | tail -n 1);
INT_IP_DB_INSTANCE=$(/usr/bin/gcloud sql instances list --filter="NAME:( sql-data-$INSTANCE_NAME )" | awk '{ print $6}' | tail -n 1);
echo -e "External IP: $INSTANCE_NAME - $EXT_IP_INSTANCE"
echo -e "Internal IP: sql-data-$INSTANCE_NAME - $INT_IP_DB_INSTANCE"

