<p align="center">
  <img src="https://raw.githubusercontent.com/HVR88/LM-Bridge-DEV/main/assets/lmbridge-icon.png" alt="LM Bridge" width="500" />
</p>

# MBMS_PLUS

**_MusicBrainz Mirror Server PLUS - Full stack with Lidarr API Bridge_**

## Quick start

```bash
git clone https://github.com/HVR88/MBMS_PLUS.git
cd MBMS_PLUS
docker compose up -d
```

## Configure

Edit `.env` (top section) before first run:

- `MUSICBRAINZ_REPLICATION_TOKEN` (required for replication)
- `MUSICBRAINZ_WEB_SERVER_HOST` / `MUSICBRAINZ_WEB_SERVER_PORT` as needed
- Optional provider keys for LM-Bridge (FANART/LASTFM/SPOTIFY)

## Notes

- First import and indexing can take hours and require large disk (hundreds of GB).
- This stack is intended for private use on a LAN behind a firewall; do not expose services publicly without hardening.

### Source code, licenses and development repo:

https://github.com/HVR88/musicbrainz_stack-DEV
