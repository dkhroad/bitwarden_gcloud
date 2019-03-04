source docker.env

if [ "$1" == "-b" ]; then
  docker run --rm \
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e DOMAIN=$DOMAIN \
    -v $CERTBOT_DIR/conf:/etc/letsencrypt \
    -v $CERTBOT_DIR/www:/var/www/certbot \
    --entrypoint /bootstrap.sh \
    dkhroad/certbot
elif [ "$1" == "-c" ]; then 
  docker run --rm \
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e DOMAIN=$DOMAIN \
    --volumes-from nginx \
    --entrypoint /bootstrap.sh \
    dkhroad/certbot -rm
elif [ "$1" == "-r" ]; then 
  docker run --rm \
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e DOMAIN=$DOMAIN \
    --volumes-from bitwarden \
    --entrypoint /reqcert.sh \
    dkhroad/certbot 
else 
  docker run -d --restart=unless-stopped --name certbot\
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e DOMAIN=$DOMAIN \
    --volumes-from nginx \
    dkhroad/certbot 
fi

