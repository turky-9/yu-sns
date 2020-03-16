FROM alpine:3.11.3

LABEL maintainer="haru <udk-tech.work>"

# RUN: docker buildするときに実行される
# /run/openldapはpidファイル
# /var/lib/openldap/runはUnix Domain Socket
RUN apk add openldap openldap-clients openldap-back-mdb && mkdir -p /run/openldap && mkdir -p /var/lib/openldap/run && rm -rf /var/cache/apk/*
EXPOSE 389
EXPOSE 636

ENTRYPOINT slapd -h "ldap:/// ldapi:///" -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d  && tail -f /dev/null
