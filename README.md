# protonmail-bridge rootless

[![Auto-build Proton Bridge image](https://github.com/Lanjelin/proton-bridge-rootless/actions/workflows/build-and-publish.yml/badge.svg)](https://github.com/Lanjelin/proton-bridge-rootless/actions/workflows/build-and-publish.yml)

Protonmail-bridge built for Docker using [Alpine Linux](https://hub.docker.com/_/alpine) baseimage.  
Built from [source](https://github.com/ProtonMail/proton-bridge/releases), and running rootless.

## Application Setup

Start the container with a named volume, or a bind mount mapped to `/data`  
The container runs with user id 99, ensure mounted dir is owned by this.

### Setting up the bridge

1. Connect to the running container `docker attach protonmail-bridge`
2. Use the `login` command to add your ProtonMail account. You will be prompted to enter your ProtonMail username and password.
3. After the account is added and completed the initial sync, use the `info` command to see the configuration information for the bridge password.
4. When you are done, press `CTRL+P` followed by `CTRL+Q`. This detaches the container from your terminal and keeps it running in the background.

### Ports
This image exposes client-facing ports 143 (IMAP) and 587 (SMTP). Proton Bridge internally uses 1143/1025; the container maps those via socat.
Internal ports can be changed by setting ENV `IMAP_PORT` and `SMTP_PORT`. External ports is changed as usual.
> Security note: these ports are plaintext. Use only on localhost/LAN/VPN (WireGuard/Tailscale).  
> If you're exposing publicly, import your cert in the bridge using `cert import`, and ensure the client forces `STARTTLS`.

### docker-compose

```yaml
services:
  protonmail-bridge:
    image: ghcr.io/lanjelin/proton-bridge-rootless:latest
    container_name: protonmail-bridge
    stdin_open: true
    tty: true
    ports:
      - "143:143" #IMAP
      - "587:587" #SMTP
    volumes:
      - ./protonmail-bridge:/data
    restart: unless-stopped
```

### docker cli

```bash
docker run -d -it \
  --name=protonmail-bridge \
  -p 143:143 \
  -p 587:587 \
  -v ./protonmail-bridge:/data \
  --restart unless-stopped \
  ghcr.io/lanjelin/proton-bridge-rootless:latest
```
