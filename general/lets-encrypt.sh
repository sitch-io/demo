echo "Setting up Let's Encrypt certificates..."
docker run -it --rm \
  -p 443:443 -p 80:80 \
  --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  quay.io/letsencrypt/letsencrypt:latest \
  certonly \
    --standalone \
    --email ${CERTBOT_EMAIL} \
    --agree-tos \
    -d ${SERVER_NAME}
