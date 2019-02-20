# get docker compose 

DOCKER_COMPOSE_VERSION="1.23.2"
docker run docker/compose:$DOCKER_COMPOSE_VERSION version

echo alias docker-compose="'"'docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD:/rootfs/$PWD" \
    -w="/rootfs/$PWD" \
    docker/compose:"$DOCKER_COMPOSE_VERSION"'"'" >> ~/.bashrc

source ~/.bashrc
