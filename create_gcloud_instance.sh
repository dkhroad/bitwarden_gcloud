set -x
INSTANCE_NAME=${1:-'bitwarden-test'}

if [ -f ./gcloud.env ]; then
  source ./gcloud.env
else 
  echo "./gcloud.env file is missing"
  exit 1
fi


gcloud compute project-info add-metadata --metadata-from-file bitwarden_env=bitwarden.env
gcloud compute project-info add-metadata --metadata-from-file docker-compose_env=docker-compose.env
gcloud compute project-info add-metadata --metadata-from-file docker_env=docker.env

gcloud compute  instances create $INSTANCE_NAME \
  --project=$PROJECT \
  --zone=$ZONE \
  --boot-disk-size=10GB  \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=$INDANCE_TEMPLATE_NAME \
  --boot-disk-device-name=$INSTANCE_NAME \
  --machine-type=f1-micro \
  --maintenance-policy=MIGRATE \
  --service-account=$SERVICE_ACCOUNT \
  --tags=http-server,https-server \
  --image=cos-stable-72-11316-136-0 \
  --image-project=cos-cloud \
  --metadata=google-logging-enabled=true \
  --metadata-from-file startup-script=./startup_script.sh

