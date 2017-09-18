FROM docker.io/sitch/self_signed_seeder

COPY generate_certs.sh /

run mkdir -p /opt/cert-export

ENTRYPOINT ""
CMD /generate_certs.sh
