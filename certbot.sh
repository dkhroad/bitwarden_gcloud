source docker.env

if [ "$1" == "-req" ]; then
  docker run --rm \
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e DOMAIN=$DOMAIN \
    --volumes-from bitwarden \
    --entrypoint /reqcert.sh \
    -p 80:80 \
    dkhroad/certbot standalone 
elif [ "$1" == "-b" ]; then 
 docker run --rm \
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e DOMAIN=$DOMAIN \
    -v $CERTBOT_DIR/conf:/etc/letsencrypt \
    -v $CERTBOT_DIR/www:/var/www/certbot \
    --entrypoint /bootstrap.sh \
    dkhroad/certbot
elif [ "$1" == "-rm" ]; then 
  docker run --rm \
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e DOMAIN=$DOMAIN \
    --volumes-from bitwarden \
    --entrypoint /bootstrap.sh \
    dkhroad/certbot -rm
else 
  docker run -d --restart=unless-stopped --name certbot\
    -e CERTBOT_EMAIL=$CERTBOT_EMAIL \
    -e DOMAIN=$DOMAIN \
    -p 80:80 \
    -v $CERTBOT_DIR/conf:/etc/letsencrypt \
    dkhroad/certbot 
fi

