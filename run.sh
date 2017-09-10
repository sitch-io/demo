source .env

bash install-docker.sh
bash lets-encrypt.sh
# Requires copying Vault keys and root token, then pasting 3 keys back
bash vault.sh
# vault root token will be requested here
bash logstash.sh

docker-compose up
