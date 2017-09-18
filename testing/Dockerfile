FROM docker.io/sitch/self_signed_seeder

COPY generate_certs.sh /

run mkdir -p /opt/cert-export

ENTRYPOINT "/bin/sh -c"
CMD "/generate_certs.sh"
