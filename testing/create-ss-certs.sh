echo "Generating local self-signed certificates..."

docker build -t localcerts .

docker run -it \
  -v /etc/certs/:/opt/cert-export \
  -e LS_CLIENTNAME=$LS_CLIENTNAME \
  -e LS_SERVERNAME=$LS_SERVERNAME \
  localcerts

mkdir -p /etc/letsencrypt/live/${LS_SERVERNAME}/

cat /etc/certs/ca.crt > /etc/letsencrypt/live/${LS_SERVERNAME}/fullchain.pem
cat /etc/certs/${LS_SERVERNAME}.crt >> /etc/letsencrypt/live/${LS_SERVERNAME}/fullchain.pem

cat /etc/certs/${LS_SERVERNAME}.key >> /etc/letsencrypt/live/${LS_SERVERNAME}/privkey.pem
