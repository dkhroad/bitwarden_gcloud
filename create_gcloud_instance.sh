set -x
INSTANCE_NAME=${1:-'bitwarden-test'}

gcloud compute project-info add-metadata --metadata-from-file bitwarden_env=bitwarden.env
gcloud compute project-info add-metadata --metadata-from-file docker-compose_env=docker-compose_cloud.env
gcloud compute project-info add-metadata --metadata-from-file bitwarden_backup_gcs_env=bitwarden_backup_gcs.env

gcloud compute  instances create $INSTANCE_NAME \
  --project=ace-thought-224822 \
  --zone=us-west1-b \
  --boot-disk-size=10GB  \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=instance-template-bitwarden \
  --boot-disk-device-name=$INSTANCE_NAME \
  --machine-type=f1-micro \
  --maintenance-policy=MIGRATE \
  --service-account=603118360062-compute@developer.gserviceaccount.com \
  --tags=http-server,https-server \
  --image=cos-stable-72-11316-136-0 \
  --image-project=cos-cloud \
  --metadata=google-logging-enabled=true \
  --metadata-from-file startup-script=./startup_script.sh
