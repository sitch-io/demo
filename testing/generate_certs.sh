echo "Move to easy-rsa directory..."
cd /usr/share/easy-rsa

./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa build-server-full $LS_SERVERNAME nopass

export CA_CERT=/usr/share/easy-rsa/pki/ca.crt
export SERVER_CERT=/usr/share/easy-rsa/pki/issued/$LS_SERVERNAME.crt
export SERVER_KEY=/usr/share/easy-rsa/pki/private/$LS_SERVERNAME.key

cp ${CA_CERT} ${SERVER_CERT} ${SERVER_KEY} /opt/cert-export
