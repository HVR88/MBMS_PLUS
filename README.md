<p align="center">
  <img src="https://raw.githubusercontent.com/HVR88/LM-Bridge-DEV/main/assets/lmbridge-icon.png" alt="LM Bridge" width="500" />
</p>

# MBMS PLUS

**_MusicBrainz Mirror Server PLUS - Full stack with Lidarr API Bridge_**

## Quick start

### 1. Register for MusicBrainz access

1. Create an account at https://MusicBrainz.com
2. Get your _Live Data Feed Access Token_ from Metabrainz https://metabrainz.org/profile

### 2. Download the pre-built containers

```
mkdir -p /opt/docker/
cd /opt/docker/
git clone https://github.com/HVR88/MBMS_PLUS.git
cd /opt/docker/MBMS_PLUS
```

### 3. Minimally Configure .env

Edit `.env` (top section) before first run:

- Remove the `NO_OP` line from the **.env** file
- `MUSICBRAINZ_REPLICATION_TOKEN` (required for replication)
- `MUSICBRAINZ_WEB_SERVER_HOST` ('localhost' default, edit as needed)
- `MUSICBRAINZ_WEB_SERVER_PORT` ('5000' default, edit as needed)
- Optional provider keys for LM-Bridge (FANART/LASTFM/SPOTIFY)

### 4. Start the containers

```
docker compose up -d
```

## Notes

- First import and indexing can take hours and require large disk (hundreds of GB).
- This stack is intended for private use on a LAN behind a firewall; do not expose services publicly without hardening.

### Source code, licenses and development repo:

https://github.com/HVR88/musicbrainz_stack-DEV
