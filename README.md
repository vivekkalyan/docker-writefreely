# docker-writefreely

A production docker container for writefreely designed to work with the
linuxserver/letsencrypt.

## Run locally

```
docker build . -t wf
docker run -p 8080:8080 -it -e APP_TITLE='Title' --rm -v ~path/to/data:/data wf
```

## Docker Compose

```
---
version: "2"
services:
  writefreely:
    image: vivekkalyan/docker-writefreely:arm7
    container_name: writefreely
    environment:
      - APP_TITLE="Title"
      - APP_URL="https:\/\/subdomain.domain.com"
    volumes:
      - /path/to/data/:/data
    ports:
      - 8080:8080
    restart: unless-stopped

```

Check the full list of environmental variables and their defaults in the
`bin/docker-writefreely.sh`

## nginx proxy conf

```
# make sure that your dns has a cname set for writefreely

server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name subdomain.*;

    include /config/nginx/ssl.conf;

    client_max_body_size 0;

    location / {
        include /config/nginx/proxy.conf;
        resolver 127.0.0.11 valid=30s;
        set $upstream_writefreely writefreely;
#       proxy_max_temp_file_size 2048m;
        proxy_pass http://$upstream_writefreely:8080;
    }
}
```
