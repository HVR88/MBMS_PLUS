<p align="center" style="white-space: nowrap;">
  <img src="https://raw.githubusercontent.com/HVR88/Docs-Extras/master/LimboLogo.png" alt="Limbo" width="360" />
</p>

# <p align="center"><sub>**_Lidarr Tools | Downloader | Data Server_**</sub></p>

## Introduction

Limbo is a multi-purpose tool and download manager for Lidarr. It contains a full MusicBrainz mirror server with fast, easy and automated installation. No plugins or settings need to be changed in Lidarr.

Limbo packages the Lidarr Metadata API and bridges queries to the mirror database directly, providing local access to all metadata. No online Lidarr databases, "cache-warming" or other nonsense. Just fast LAN-based performance.

_You say that you don't want vinyl formats in releases? No problem, filter that out._

From the Limbo WebUI, you can filter/modify media formats for all releases, set up additional data providers (not normally supported by Lidarr) and fix artwork downloading for those it already supports.

**Currently implemented features:**

- Library Statistics
- Release filtering (block specific media formats: vinyl, tape, etc.)
- Release / Artist refreshing (paste URL/ID single/bulk and refrecs albums/artists)
- Expanded Art + Data providers selection, with drag & drop priority order
- Automated / Manual Download Manager (partial - slskd)

Other features are currently in development or testing. Update notifications are displayed at the bottom of the Limbo WebUI.

<p align="center">
  <img src="https://github.com/HVR88/Docs-Extras/blob/master/Limbo-open-1.9.227.png?raw=true" alt="Limbo" width="600" />
</p>

## Requirements

- Linux server / VM / LXC with Docker support
- 300 GB of available storage (400-500 GB recommended)
  - Additional storage for optional downloading and music sharing
- 8 GB of memory available to the container
- 2-4 hours installation time
- MusicBrainz account and Data Feed access token

## Quick Start

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

Next configure these minimum variables in the .env file:

- Set **`MUSICBRAINZ_REPLICATION_TOKEN`** (get from https://metabrainz.org/profile)

- Set **LIMBO_SLSKD_PARENT_MOUNT** (must point at a real mount)
  - example: /mnt/MY_SMB_NAS_SHARE

_Download features will be unavailable without this variable set._
The path is available in slskd as "/music" and slskd's share folder is set as "/music/shared_files" by default. You can change this in the webUI to any other folder under "/music" to point to the music files you want to share

You can optionally set the following variables if you want a different top-level for your download or share folders. Otherwise, you can set them under /music in the webUI:

- Set **LIMBO_SLSKD_DOWNLOADS_MOUNT**
- Set **LIMBO_SLSKD_INCOMPLETE_DOWNLOADS_MOUNT**
- Set **LIMBO_SLSKD_SHARING_MOUNT**

> [!TIP]
>
> When deploying from a terminal, use _screen_ or _tmux_ so the compose process can continue running if your session drops (closing the window, computer goes to sleep, etc.)

### 4. Download containers, build DB & start up (!) _This takes 2-4 hours_

```
docker compose up -d
```

## Wrap-Up

You can monitor the progress of the long first-time installation jobs from another terminal:

```
docker compose logs -f --timestamps
```

Or with less "noise:"

```
docker compose logs -f --no-log-prefix --tail=200 \
  bootstrap search-bootstrap search musicbrainz indexer indexer-cron limbo slskd

```

## Browser Access / Status

**Limbo** web UI: **http://HOST_IP:5001**

**SLSKD** web UI: **http://HOST_IP:5030** (HTTPS: `5031`)

**MusicBrainz** local web site: **http://HOST_IP:5000**
<br>(Off by default, enable it in Limbo Provider Settings)

> [!TIP]
>
> Put a reverse proxy (NPM, Caddy, Traefik, SWAG) in front of your host IP and use your own (sub)domains to reach Limbo, slskd and MusicBrainz LOCALLY on port 80 (HTTP) or 443 (HTTPS) (requries a unique host name per service, like limbo.yourdomain.net, slskd.yourdomain.net and mbrainz.yourdomain.net)

## Updates

The `.env` file is user-maintained and won't be changed when updating. Updating will refresh all other managed files automatically: admin scripts,
compose template, and defaults, including _example.env._

### Regular update

Pull the latest images and restart:

```
docker compose pull
docker compose up -d
```

### Major update (with new components, etc.)

Pull the latest images and restart two times:

```
docker compose pull
docker compose up -d
(docker compose down) - optional
docker compose up -d
```

You should also look in the _`example.env`_ file for updates that may need to be applied to `.env` - if there are new required variables, you should get a warning on the second compose up.

## Limbo Configuration

**WORK IN PROGRESS**

Go to **http://<your_LIMBO_IP>:5001**

_**Use the SETTINGS button on the top right of the webUI to configure your Lidarr IP address, port and API KEY. The API Key can be found in Lidarr's Settings -> General page.**_

## Notes

- _Continued (scheduled) replication and indexing is required to keep the database up-to-date and at optimal performance_
- This stack is configured for private use on a LAN, behind a firewall, **IT'S NOT SECURED FOR THE OPEN INTERNET**

> [!NOTE]
>
> Limbo is for personal use only

### Source code, licenses and development repo:

https://github.com/HVR88/DEV_Limbo-Stack

## Maintenance (optional)

Keep database scheduled tasks and mainenance options enabled in Limbo Settings.

Additional helper scripts are synced into `admin/` automatically when the stack starts or updates:

- `admin/status` (show container status)
- `admin/logs [services...]` (follow logs)
- `admin/restart [services...]` (restart services)
- `admin/replicate-now` (trigger replication immediately)
- `admin/reindex-now` (trigger search reindex)
- `admin/soulseek-auth-set --rotate [--json]` (roll and apply a generated Soulseek username/password)
- `admin/soulseek-auth-set --username <name> [--password <pass>] [--json]` (pre-validates Soulseek login before apply; returns error instead of rotating on failure)
- `admin/bootstrap-reset` (clear bootstrap markers; prompts for confirmation)
