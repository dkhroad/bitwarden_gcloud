source docker.env

if [ "$1" == "-r" ]; then
  docker run --rm \
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e DOMAIN=$DOMAIN \
    --volumes-from bitwarden \
    --entrypoint /reqcert.sh \
    dkhroad/certbot standalone 
else 
  docker run -d --restart=unless-stopped --name certbot\
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e DOMAIN=$DOMAIN \
    --volumes-from nginx \
    dkhroad/certbot 
fi

