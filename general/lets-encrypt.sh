echo "Setting up Let's Encrypt certificates..."
docker run -it \
  -p 443:443 -p 80:80 \
  --name certbot \
  -v "/etc/letsencrypt:/etc/letsencrypt" \
  -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
  --network=host \
  -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
  docker.io/certbot/certbot:latest \
    certonly \
      --standalone \
      --email ${CERTBOT_EMAIL} \
      --no-eff-email \
      --agree-tos \
      -d ${SERVER_NAME} ${ADDITIONAL_CERTBOT_ARGS}

# docker commit certbot certboat

# echo "Dumping letsencrypt logs..."
# docker run -it \
#  --name certyboaty \
#  --entrypoint /bin/cat \
#  certboat \
#  /var/log/letsencrypt/letsencrypt.log
