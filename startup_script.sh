#!/bin/bash
set -x

# cleanup 
rm -rf /home/bitwarden/bitwarden_gcloud
rm -rf /home/bitwarden/dkhroad-bitwarden_gcloud*
mkdir -p /home/bitwarden

# setup 
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.23.2/run.sh -o /home/bitwarden/docker-compose 

# download containers
curl -L https://github.com/dkhroad/bitwarden_gcloud/tarball/master | tar xvfz - -C /home/bitwarden
ln -s /home/bitwarden/dkhroad-bitwarden_gcloud-* /home/bitwarden/bitwarden_gcloud

# set up env 
git clone https://github.com/dkhroad/bitwarden_gcloud.git /home/bitwarden/bitwarden_gcloud
curl http://metadata.google.internal/computeMetadata/v1/project/attributes/bitwarden_env -H "Metadata-Flavor: Google" > /home/bitwarden/bitwarden_gcloud/bitwarden.env
curl http://metadata.google.internal/computeMetadata/v1/project/attributes/docker-compose_env -H "Metadata-Flavor: Google" > /home/bitwarden/bitwarden_gcloud/.env

# Assign the static IP to the instance if not already done

# create a dummy cert if bringing up the containers for the first time
(cd /home/bitwarden/bitwarden_gcloud; bash ../docker-compose run --rm --entrypoint /bootstrap.sh certbot)
# restore bitwarden data
(cd /home/bitwarden/bitwarden_gcloud; bash ../docker-compose run --rm --entrypoint /restore.sh backup_gcs)
# start containers
(cd /home/bitwarden/bitwarden_gcloud; bash ../docker-compose up -d)
# remove the fake cert now that nginx is up
(cd /home/bitwarden/bitwarden_gcloud; bash ../docker-compose run --rm --entrypoint /bootstrap.sh certbot -rm)
# request a letsencrypt certificate with webroot plugin
(cd /home/biwarden/bitwarden_gloud; bash   ../docker-compose run --rm --entrypoint /reqcert.sh certbot)
# reload nginx
(cd /home/bitwarden/bitwarden_gcloud; bash ../docker-compose exec nginx nginx -s reload)



