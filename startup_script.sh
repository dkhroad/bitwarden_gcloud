#!/bin/bash
set -x

# cleanup 
rm -rf /home/bitwarden/bitwarden_gcloud
rm -rf /home/bitwarden/dkhroad-bitwarden_gcloud*
mkdir -p /home/bitwarden

# setup 
#sudo curl -L --fail https://github.com/docker/compose/releases/download/1.23.2/run.sh -o /home/bitwarden/docker-compose 

# download containers
curl -L https://github.com/dkhroad/bitwarden_gcloud/tarball/master | tar xvfz - -C /home/bitwarden
ln -s /home/bitwarden/dkhroad-bitwarden_gcloud-* /home/bitwarden/bitwarden_gcloud

# set up env 
git clone https://github.com/dkhroad/bitwarden_gcloud.git /home/bitwarden/bitwarden_gcloud
curl http://metadata.google.internal/computeMetadata/v1/project/attributes/bitwarden_env -H "Metadata-Flavor: Google" > /home/bitwarden/bitwarden_gcloud/bitwarden.env
curl http://metadata.google.internal/computeMetadata/v1/project/attributes/docker-compose_env -H "Metadata-Flavor: Google" > /home/bitwarden/bitwarden_gcloud/.env
curl http://metadata.google.internal/computeMetadata/v1/project/attributes/docker_env -H "Metadata-Flavor: Google" > /home/bitwarden/bitwarden_gcloud/docker.env


# Assign the static IP to the instance if not already done


# restore bitwarden data
# bash -x ./backup.sh -r

# start containers
# bash -x ./certbot.sh -req
# bash -x ./certbot.sh 
# bash -x ./bitwarden.sh 
# bash -x ./backup.sh 
# bash -x ./backup.sh -gcs



