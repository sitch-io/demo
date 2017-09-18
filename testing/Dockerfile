FROM docker.io/sitch/self_signed_seeder

COPY generate_certs.sh /

run mkdir -p /opt/cert-export

CMD /bin/sh /generate_certs.sh
