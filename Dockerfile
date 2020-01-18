FROM lsiobase/nginx:3.11

ARG WRITEFREELY_RELEASE=0.11.2

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache --upgrade \
     curl \
 echo "**** download writefreely ****" && \
 curl -o /app/writefreely.tar.bz2 -L \
    https://github.com/writeas/writefreely/releases/download/v${WRITEFREELY_RELEASE}/writefreely_${WRITEFREELY_RELEASE}_linux_amd64.tar.gz | tar -C / -xzf - && \

COPY bin/writefreely-docker.sh /writefreely/

WORKDIR /writefreely
VOLUME /data
EXPOSE 8080

ENTRYPOINT ["/writefreely/writefreely-docker.sh"]
