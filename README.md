<p align="center">
  <img src="https://raw.githubusercontent.com/HVR88/LM-Bridge-DEV/main/assets/lmbridge-icon.png" alt="LM Bridge" width="500" />
</p>

# MBMS PLUS

**_MusicBrainz Mirror Server PLUS - Full stack with Lidarr API Bridge_**

The initial "compose up" will start with 3.5GB download, and the full installation after setup needs an additional 300GB. **This setup takes at least a few hours.**

_It's recommended to install onto a volume with at least 500GB free to allow for future replication and updates._

> [!TIP]
>
> If you're deploying from a terminal session, use screen or tmux so the compose process can continue running if your terminal session drops (closing the window, computer goes to sleep, etc.)

> [!CAUTION]
>
> This container stack is exclusively for personal use. **NO COMMERCIAL OR BUSINESS USE IS PERMITTED.**

## Quick start

### 1. Register for MusicBrainz access - REQUIRED

- Create an account at https://MusicBrainz.com
- Get your _Live Data Feed Access Token_ from Metabrainz https://metabrainz.org/profile

### 2. Download the MBMS_PLUS project - Small and quick

```
mkdir -p /opt/docker/
cd /opt/docker/
git clone https://github.com/HVR88/MBMS_PLUS.git
cd /opt/docker/MBMS_PLUS
```

### 3. Minimally Configure .env file - REQUIRED

Edit `.env` (top section) before first run:

- Uncomment `COMPOSE_PROFILES=mbms`
- `MUSICBRAINZ_REPLICATION_TOKEN` (required for replication)
- `MUSICBRAINZ_WEB_SERVER_HOST` ('localhost' default, edit as needed)
- `MUSICBRAINZ_WEB_SERVER_PORT` ('5000' default, edit as needed)
- Optional provider keys/tokens for LM-Bridge (Cover Art Archive/Fanart/Last.FM)

### 4. Start the containers download and startup - 300GB, Takes hours

```
docker compose up -d
```

## Wrap-up

You can monitor the progress of the long database jobs:

```
docker compose logs -f --no-log-prefix bootstrap
```

When finished, your MusicBrainz mirror will be available at **http://HOST_IP_Address:5000**
<br>The Lidarr API bridge will accept connections at the same address on port 5001

> [!TIP]
>
> Put a reverse proxy (NPM, Caddy, Traefik, SWAG) in front of your host IP and use your own (sub)domain to reach your MusicBrainz mirror on port 80 (HTTP) or 443 (HTTPS)

## Notes

- First import and indexing will take hours and requires up to 300GB of available storage
- This stack is intended for private use on a LAN behind a firewall; don't expose services publicly without hardening

### Source code, licenses and development repo:

https://github.com/HVR88/musicbrainz_stack-DEV
