source docker.env 

docker run -d --restart=unless-stopped  --name bitwarden --env-file ./bitwarden.env \
  -e DOMAIN:$DOMAIN \
  -v $HOST_BW_DATA_DIR:/data \
   mprasil/bitwarden
