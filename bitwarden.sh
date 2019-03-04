source docker.env 

docker run -d --restart=unless-stopped  --name bitwarden --env-file ./bitwarden.env \
  -e DOMAIN:$DOMAIN \
  -e ROCKET_TLS="{certs=\"/etc/letsencrypt/live/$DOMAIN/fullchain.pem\",key=\"/etc/letsencrypt/live/$DOMAIN/privkey.pem\"}" 
  -v $HOST_BW_DATA_DIR:/data \
   mprasil/bitwarden
