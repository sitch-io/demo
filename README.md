# Sitch demo environment
## Makes things a _little_ bit easier

[![Join the chat at https://gitter.im/sitch-io/demo](https://badges.gitter.im/sitch-io/demo.svg)](https://gitter.im/sitch-io/demo?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This docker-compose configuration will make setting up a test environment for
SITCH a little easier.

### Important Note

If you've already set up the SITCH demo environment and you just want the
updated app components for the ELK stack, use the release tagged `v0.9` from
this repo.  That updates the ELK stack and leaves InfluxDB alone.  In order to
update InfluxDB, the back-end ports in the `sitch-io/web` component will need
to be changed.  If you're not looking to update InfluxDB, stay with `v0.9`

 

Here's the process for setting up the service side of SITCH:

### Pre-requisites
  * Accounts with:
    * Twilio
    * OpenCellID (API key required)
    * Resin.io
    * Slack
  * One provisioned instance (CoreOS preferred)
    * At least 40GB of storage mounted at /opt
    * 4GB RAM
  * Public DNS-resolving hostname assigned to the instance

### Doing the thing
1. SSH into the instance and set up your certificates (fill in
  SERVER_DNS_NAME_HERE with your server's DNS name):

        docker run -it --rm \
        -p 443:443 -p 80:80 \
        --name certbot \
        -v "/etc/letsencrypt:/etc/letsencrypt" \
        -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
        quay.io/letsencrypt/letsencrypt:latest \
        certonly

1. Start Vault (replace SERVER_DNS_NAME_HERE as in the prior step):

        docker run -d  \
        --cap-add=IPC_LOCK \
        -p 8200:8200  \
        -v /etc/letsencrypt/:/etc/letsencrypt/ \
        -e 'VAULT_LOCAL_CONFIG={"backend": {"file": {"path": "/vault/file"}},"listener":{"tcp":{"address":"0.0.0.0:8200","tls_cert_file": "/etc/letsencrypt/live/SERVER_DNS_NAME_HERE/fullchain.pem","tls_key_file":"/etc/letsencrypt/live/SERVER_DNS_NAME_HERE/privkey.pem"}},"default_lease_ttl": "7200h", "max_lease_ttl": "7200h"}' \
        --name sitch_vault \
        vault:v0.6.0 server

1. Unseal the vault:
    1. `docker exec sitch_vault vault init --tls-skip-verify`
    1. You'll notice that it returns a list of keys.  Three of those keys must
    be used to unseal the Vault.  Record these keys in a password manager!
    1. Run this: `docker exec -it sitch_vault vault unseal --tls-skip-verify`
    and you'll be prompted to enter a key.  Use one of the keys from the prior
    step.  Do this three times total and the vault will unseal.
1. Generate the Logstash certificates (VAULT_URL is
  https://YOUR_SERVER_NAME:8200. VAULT_TOKEN is the root token you recorded
  just before going through the process of unsealing the vault.  LS_CLIENTNAME
  is just a valid hostname, does not need to resolve.  LS_SERVERNAME is the
  same name you used in generating your certs with the certbot docker
  container, above. Must have 8200:TCP open.):

        docker run -it \
        -e VAULT_URL=$VAULT_URL \
        -e VAULT_TOKEN=$VAULT_TOKEN \
        -e LS_CLIENTNAME=$LS_CLIENTNAME \
        -e LS_SERVERNAME=$LS_SERVERNAME \
        docker.io/sitch/self_signed_seeder

1. Run the feed builder.  See instructions here:
  https://hub.docker.com/r/sitch/feed_builder/
1. Clone this repo to the CoreOS instance, and descend into the root directory
    of the repository:
        git clone https://github.com/sitch-io/demo && \
        cd sitch-demo
1. Use your favorite editor (which is vi, right?? :trollface:) to complete the
  environment variables in the .env file.  Retain the information in the file
  securely (password manager, etc) and delete it when you're done.
1. Use docker-compose to complete the setup of your environment:
    `docker-compose up`

### Wrapping up
If you've not been opening ports as you go along, let's have a look at your
firewall to ascertain that you'e only got the necessary ports open, and only to
the IPs where they're needed.
Specifically, we're talking about outside access to the CoreOs instance.  If
you're awesome, you'll implement this in CoreOS as well as your IAAS provider.  
Look at the table below for guidance.

| Port/Protocol | Purpose                                                                 |
|---------------|-------------------------------------------------------------------------|
| 80            | Only necessary while using certbot to obtain certs.                     |
| 443           | Feeds served up on this port. Sensors must be able to access this port. |
| 1000          | HTTPS access to Chronograf.  Only needed for admins.                    |
| 5001          | Logstash port.  Needs to be open to each Sensor                         |
| 8443          | HTTPS access to Kibana.  Only needed for admins.                        |

Once events are flowing in, you'll need to tell Elasticsearch how to parse
SITCH geolocation info.  Go to the Elasticsearch developer console and use this
query to enable this functionality:

```
PUT _template/logstash/
{
  "template": "logstash-*",
  "mappings": {
    "_default_": {
      "dynamic_templates": [
        {
          "string_fields": {
            "match_mapping_type": "string",
            "mapping": {
              "type": "text"
            }
          }
        }
      ],
      "properties": {
        "gps_location": {
          "type": "geo_point"
        }
      }
    }
  }
}

```

### What's next??
Access control!  Make sure that 1000 and 8443 are only accessible to the right
people by implementing OpenVPN and IP address restrictions, or some other
method.  There are no authentication mechanisms implemented in the
browser-accessible part of the application, yet.

Finally: Set up your sensors (https://github.com/sitch-io/sensor) and watch
your Slack channel for alerts.  Bonus points for creating a nice dashboard in
Kibana and/or Chronograf.
