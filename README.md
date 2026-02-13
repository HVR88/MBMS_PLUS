<p align="center">
  <img src="https://raw.githubusercontent.com/HVR88/LM-Bridge-DEV/main/assets/lmbridge-icon.png" alt="LM Bridge" width="500" />
</p>

# <p align="center">**_MusicBrainz Mirror Server PLUS_**<br><sub>**Full stack with Lidarr API Bridge**</sub></p>

## Introduction

> [!TIP]
>
> When deploying from a terminal, use screen or tmux so the compose process can continue running if your session drops (closing the window, computer goes to sleep, etc.)

## Requirements

- Docker Host, engine & management - examples:
  - Linux server / VM / LXC with Docker Compose, Portainer, Yacht, etc.
  - Unraid + Docker Compose Manager
  - TrueNAS
- 300 GB of available storage (400-500 GB recommended)
- 8 GB of memory availbale to the container
- 2-4 hours installation time

## Quick start

### 1. Register for MusicBrainz access (REQUIRED)

- Create an account at https://MusicBrainz.com
- Get your _Live Data Feed Access Token_ from Metabrainz https://metabrainz.org/profile

### 2. Download the MBMS_PLUS project

```
mkdir -p /opt/docker/
cd /opt/docker/
git clone https://github.com/HVR88/MBMS_PLUS.git
cd /opt/docker/MBMS_PLUS
```

### 3. Minimally Configure .env file (REQUIRED)

Edit `.env` (top section) before first run:

- Uncomment `COMPOSE_PROFILES=mbms`
- `MUSICBRAINZ_REPLICATION_TOKEN` (required for replication)
- `MUSICBRAINZ_WEB_SERVER_HOST` ('localhost' default, edit as needed)
- `MUSICBRAINZ_WEB_SERVER_PORT` ('5000' default, edit as needed)
- Optional provider keys/tokens for LM-Bridge (Cover Art Archive/Fanart/Last.FM)

### 4. Download containers, build DB & startup

```
docker compose up -d
```

## Wrap-up

You can monitor the progress of the long compose jobs:

```
docker compose logs -f --timestamps
```

Or with less "noise"

```
docker compose logs -f --no-log-prefix --tail=200 \
  bootstrap search-bootstrap search musicbrainz indexer indexer-cron lmbridge

```

When finished, your MusicBrainz mirror will be available at **http://HOST_IP_Address:5000**
<br>The Lidarr API bridge will accept connections at the same address on port 5001

> [!TIP]
>
> Put a reverse proxy (NPM, Caddy, Traefik, SWAG) in front of your host IP and use your own (sub)domain to reach your MusicBrainz mirror on port 80 (HTTP) or 443 (HTTPS) on your LAN

## Notes

- _The first import and database setup will take multiple hours and requires up to 300GB of available storage_
- Building Materialized/denormalized tables adds additioonal GB of storage but offers significant performance improvements
- 60GB of pre-built search indexes are downloaded to save a significant amount of time building new indexes
- This stack is intended for private use on a LAN behind a firewall; don't expose services publicly without hardening

> [!INFORMATION]
>
> This container stack is exclusively for personal use. **NO COMMERCIAL OR BUSINESS USE IS PERMITTED.**

### Source code, licenses and development repo:

https://github.com/HVR88/musicbrainz_stack-DEV
