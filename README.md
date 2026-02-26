<p align="center">
  <img src="https://raw.githubusercontent.com/HVR88/Limbo_DEV/main/assets/limbo-icon.png" alt="Limbo" width="400" />
</p>

# <p align="center">**_Limbo for Lidarr_**<br><sub>**Tools WebUI & Full Stack MusicBrainz Server**</sub></p>

## Introduction

Limbo is a set of tools and data bridge for Lidarr, It also contains a MusicBrainz mirror server featuring automated installation. Limbo packages the Lidarr Metadata API, and bridges queries to MusicBrainz database, allowing 100% local access to all metadata. That means no more issues with Lidarr database schemas, pre-caching or other nonsense. Just FAST LAN-based performance.

Limbo features its own WebUI, supporting filtering and manipulating media format data for all releases. Maybe you don't want vinyl variations showing up in releases? No problem, filter that out. Maybe you want large media lists to be pruned to focus only on the top candidates - that's easy too.

> [!TIP]
>
> When deploying from a terminal, use _screen_ or _tmux_ so the compose process can continue running if your session drops (closing the window, computer goes to sleep, etc.)

## Requirements

- Linux server / VM / LXC with Docker support
- 300 GB of available storage (400-500 GB recommended)
- 8 GB of memory available to the container
- 2-4 hours installation time
- MusicBrainz account and Data Feed access token

## Quick start

> [!NOTE]
>
> ### Migration from older versions, see instructions below

### 1. Register for MusicBrainz access & token

- Create an account at https://MusicBrainz.com
- Get your _Live Data Feed Access Token_ from Metabrainz https://metabrainz.org/profile

### 2. Download the Limbo compose files (no git required)

Create a folder and download the latest `docker-compose.yml` and `example.env`
from the Limbo release assets (or the raw files in this repo).

```bash
mkdir -p /opt/docker/limbo
cd /opt/docker/limbo
curl -fsSL -o limbo-latest.zip https://github.com/HVR88/Limbo/releases/latest/download/limbo-1.9.12.zip
unzip -o limbo-latest.zip
```

### 3. Copy and configure env file

Copy `example.env` to `.env`, then edit the top section before first run:

```bash
cp example.env .env
```

- Set **`MUSICBRAINZ_REPLICATION_TOKEN`**
- Set the **`MUSICBRAINZ_REPLICATION_TOKEN`** (required for replication)
- `MUSICBRAINZ_WEB_SERVER_HOST` ('localhost' default, edit as needed)
- `MUSICBRAINZ_WEB_SERVER_PORT` ('5000' default, edit as needed)
- Optional provider keys/tokens for Limbo (TheAudioDB, Fanart, Last.FM, etc.)

Only `.env` is user-maintained. The stack refreshes managed files (admin scripts,
compose template, and defaults) automatically when you update.

### 4. Download containers, build DB & startup (!) This takes 2-4 hours

```
docker compose up -d
```

## Wrap-up

You can monitor the progress of the long first-time installation jobs from another terminal:

```
docker compose logs -f --timestamps
```

Or with less "noise:"

```
docker compose logs -f --no-log-prefix --tail=200 \
  bootstrap search-bootstrap search musicbrainz indexer indexer-cron limbo

```

## Browser access / status

When finished, the Limbo settings are available at **http://HOST_IP:5001**

And the standard MusicBrainz webUI at **http://HOST_IP:5000**

> [!TIP]
>
> Put a reverse proxy (NPM, Caddy, Traefik, SWAG) in front of your host IP and use your own (sub)domains to reach your Limbo and MusicBrainz LOCALLY on port 80 (HTTP) or 443 (HTTPS) (requries two host names, like limbo.yourdomain.net and mbrainz.yourdomain.net)

## Updates

Pull the latest images and restart:

```
docker compose pull
docker compose up -d
```

If a release updates `docker-compose.yml`, run `docker compose up -d` again
after the first restart so the new compose file is applied.

## Migration from previous MBMB_PLUS installs

If you previously cloned the old repo, update your git remote once:

1. `git remote set-url origin https://github.com/HVR88/Limbo`
2. `git pull`

If you were using zip downloads, replace your `docker-compose.yml` and
`example.env` with the new release assets, then re-apply your `.env` settings.
Example:

```bash
curl -fsSL -o limbo-latest.zip https://github.com/HVR88/Limbo/releases/latest/download/limbo-latest.zip
unzip -o limbo-latest.zip
```

### Migrating project volumes (prefix and docker folder names)

When MBMS*PLUS was originally installed, the folder name was used as the project name, which set up volumes with a `mbms_plus*`prefix. However, since the project update and new name, Compose looks for volumes with the new`limbo\_` prefix and will error out. To fix this, you can do one of the following two options:

First, stop the running containers

```
docker compose stop
```

**Option 1:**
**Keep using existing `mbms_plus` parent folder and volumes (easy and fast)**

- Keep the folder name as `mbms_plus`
- Set `COMPOSE_PROJECT_NAME=mbms_plus` in `.env`

### - _OR_ -

**Option 2:**
**Migrate to new `limbo` volumes (recommended for new layout)**

- Rename the docker folder to `limbo`:
  ```bash
  mv MBMS_PLUS limbo
  ```
- Replace `docker-compose.yml` and `example.env` with the new release assets, then re-apply your `.env` values.

- Run the migration script included in the `admin/` folder as part of the zip or pull:

  ```bash
  admin/upgrade-volumes
  ```

  The name and size of each volume is displayed and you'll be prompted for confirmation before the migration starts.

- Once finished, start the stack:
  ```bash
  docker compose up -d
  ```

The migration script copies data from `mbms_plus_*` to `limbo_*` volumes.

After verifying everything works using the new volumes, the old ones can be removed:

```bash
admin/upgrade-volumes --cleanup
```

## Limbo Configuration

**WORK IN PROGRESS**

Verify a successful Limbo installation and check versions by opening the Limbo URL in your browser: **http://<your_LIMBO_IP>:5001**

_**Use the SETTINGS button on the top right of the webUI to configure your Lidarr IP address, port and API KEY. The API Key can be found in Lidarr's Settings -> General page.**_

## Notes

- _The first import and database setup will take multiple hours and requires up to 300GB of available storage_
- Building Materialized/denormalized tables consumes additional storage but offers significant performance improvements
- 60GB of pre-built search indexes are downloaded to save a significant amount of time building new indexes
- _Continued (scheduled) replication and indexing is required to keep the database up-to-date and at optimal performance_
- This stack is configured for private use on a LAN, behind a firewall
- _Don't expose services publicly without hardening_

> [!NOTE]
>
> Limbo is for personal use only: **NO COMMERCIAL OR BUSINESS USE IS PERMITTED**

### Source code, licenses and development repo:

https://github.com/HVR88/Limbo-MusicBrainz_DEV

## Maintenance (optional)

These helper scripts are synced into `admin/` automatically when the stack starts or updates:

- `admin/status` (show container status)
- `admin/logs [services...]` (follow logs)
- `admin/restart [services...]` (restart services)
- `admin/replicate-now` (trigger replication immediately)
- `admin/reindex-now` (trigger search reindex)
- `admin/bootstrap-reset` (clear bootstrap markers; prompts for confirmation)
