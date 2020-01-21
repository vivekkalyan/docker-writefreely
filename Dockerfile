FROM debian:stable-slim AS build

ARG WRITEFREELY_RELEASE=0.11.2

RUN apt update
RUN apt install --no-install-recommends -y curl ca-certificates
RUN curl -L https://github.com/writeas/writefreely/releases/download/v${WRITEFREELY_RELEASE}/writefreely_${WRITEFREELY_RELEASE}_linux_amd64.tar.gz | tar -C / -xzf -

# Final image
FROM debian:stable-slim AS production

COPY --from=build /writefreely /writefreely
COPY bin/writefreely-docker.sh /writefreely/
COPY config-template.ini /writefreely/

WORKDIR /writefreely
VOLUME /data
EXPOSE 8080

# ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/writefreely/writefreely-docker.sh"]
