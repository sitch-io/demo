warn=$(tput bold)$(tput setaf 1)
norm=$(tput sgr0)

echo Starting Vault...

docker run -d  \
  --cap-add=IPC_LOCK \
  -p 8200:8200  \
  -v /etc/letsencrypt/:/etc/letsencrypt/ \
  -e 'VAULT_LOCAL_CONFIG={"backend": {"file": {"path": "/vault/file"}},"listener":{"tcp":{"address":"0.0.0.0:8200","tls_cert_file": "/etc/letsencrypt/live/'$SERVER_NAME'/fullchain.pem","tls_key_file":"/etc/letsencrypt/live/'$SERVER_NAME'/privkey.pem"}},"default_lease_ttl": "7200h", "max_lease_ttl": "7200h"}' \
  --name sitch_vault \
  vault:v0.6.0 server

echo Unsealing Vault...
docker exec sitch_vault vault init --tls-skip-verify | tee ../.vault_init
grep '^UKey' ../vault_init | awk '{print $3}' > ../vault_unseal_keys
grep '^Initial Root Token' ../vault_init | awk '{print $4}' > ../vault_root_token
echo ${warn}RECORD THESE KEYS AND THE ROOT TOKEN.${norm}
echo ${warn}For your convenience, they are located in vault_init, vault_unseal_keys, and vault_root_token .${norm}
echo ${warn}To be extra safe, use srm to delete these files permanently, once you havve securely recorded their contents.${norm}
echo "When you're ready, hit return. You'll then be prompted for three of the five keys one at a time."
read
docker exec -it sitch_vault vault unseal --tls-skip-verify
docker exec -it sitch_vault vault unseal --tls-skip-verify
docker exec -it sitch_vault vault unseal --tls-skip-verify