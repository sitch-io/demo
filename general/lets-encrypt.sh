echo "Setting up Let's Encrypt certificates..."
docker run -it --rm \
  -p 443:443 -p 80:80 \
  --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  docker.io/certbot/certbot:latest \
  certonly \
    --standalone \
    --email ${CERTBOT_EMAIL} \
    --no-eff-email \
    --agree-tos \
    -d ${SERVER_NAME}
