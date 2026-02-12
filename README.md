<p align="center">
  <img src="https://raw.githubusercontent.com/HVR88/LM-Bridge-DEV/main/assets/lmbridge-icon.png" alt="LM Bridge" width="500" />
</p>

# MBMS PLUS

**_MusicBrainz Mirror Server PLUS - Full stack with Lidarr API Bridge_**

> [!CAUTION]
>
> This container stack is exclusively for personal use. **NO COMMERCIAL OR BUSINESS USE IS PERMITTED.**

_The initial "compose up" will start a 3.5GB download, with the full installation after setup needing an additional 300GB. **This setup takes at least a few hours.**_

It's recommended you install onto a volume with at least 500GB free to allow for future replication and updates.

## Quick start

### 1. Register for MusicBrainz access - REQUIRED

- Create an account at https://MusicBrainz.com
- Get your _Live Data Feed Access Token_ from Metabrainz https://metabrainz.org/profile

### 2. Download the MBMS_PLUS project (small/quick)

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
- Optional provider keys for LM-Bridge (FANART/LASTFM/SPOTIFY)

### 4. Start the containers download and startup

```
docker compose up -d
```

## Notes

- First import and indexing can take hours and require large disk (hundreds of GB).
- This stack is intended for private use on a LAN behind a firewall; do not expose services publicly without hardening.

### Source code, licenses and development repo:

https://github.com/HVR88/musicbrainz_stack-DEV
