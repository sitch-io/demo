echo Generating logstash certificates...

docker run -it \
  --net=sitch_elk \
  -e VAULT_URL=$VAULT_URL \
  -e VAULT_TOKEN=$VAULT_TOKEN \
  -e LS_CLIENTNAME=$LS_CLIENTNAME \
  -e LS_SERVERNAME=$LS_SERVERNAME \
  docker.io/sitch/self_signed_seeder
