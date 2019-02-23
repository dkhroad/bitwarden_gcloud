#!/bin/bash
set -x
# get docker compose 
DOCKER_COMPOSE_VERSION="1.23.2"
docker run docker/compose:$DOCKER_COMPOSE_VERSION version

mkdir -p /home/bitwarden
docker_compose="'"'docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD:/rootfs/$PWD" \
    -w="/rootfs/$PWD" \
    docker/compose:'$DOCKER_COMPOSE_VERSION"'"

echo alias docker-compose="$docker_compose" > /home/bitwarden/.bashrc

rm -rf /home/bitwarden/bitwarden_gcloud
git clone https://github.com/dkhroad/bitwarden_gcloud.git /home/bitwarden/bitwarden_gcloud
curl http://metadata.google.internal/computeMetadata/v1/project/attributes/bitwarden_env -H "Metadata-Flavor: Google" > /home/bitwarden/bitwarden_gcloud/bitwarden.env
curl http://metadata.google.internal/computeMetadata/v1/project/attributes/docker-compose_env -H "Metadata-Flavor: Google" > /home/bitwarden/bitwarden_gcloud/.env
curl http://metadata.google.internal/computeMetadata/v1/project/attributes/bitwarden_backup_gcs_env  -H "Metadata-Flavor: Google" > /home/bitwarden/bitwarden_gcloud/bitwarden_backup_gcs.env

source /home/bitwarden/.bashrc
(cd /home/bitwarden/bitwarden_gcloud &&
docker run --rm  \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD:/rootfs/$PWD" \
    -w="/rootfs/$PWD"  docker/compose:$DOCKER_COMPOSE_VERSION up backup backup_gcs)
    
