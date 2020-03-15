FROM alpine:3.11.3

LABEL maintainer="haru <udk-tech.work>"

# RUN: docker buildするときに実行される
RUN apk add openldap openldap-back-mdb && mkdir -p /run/openldap && rm -rf /var/cache/apk/*

EXPOSE 389
EXPOSE 636

ENTRYPOINT slapd -h "ldap:///" && tail -f /dev/null
