source docker.env
docker run -d --restart=unless-stopped --name nginx\
  -v $NGINX_CONF_DIR:/etc/nginx/conf.d \
  -v $CERTBOT_DIR/conf:/etc/letsencrypt \
  -v $CERTBOT_DIR/www:/var/www/certbot  \
  -e ESC='$' \
  -e SERVER_FQDN=$DOMAIN \
  nginx:mainline-alpine /bin/sh -c 'envsubst < /etc/nginx/conf.d/app.conf.tmpl > /etc/nginx/conf.d/app.conf && exec nginx -g "daemon off;" && \
    while :; do sleep 6h & wait $${i}; nginx -s reload; done & nginx -g "daemon off;"'
