<p align="center" style="white-space: nowrap;">
  <img src="https://raw.githubusercontent.com/HVR88/Docs-Extras/refs/heads/master/limbo-logo.svg" alt="Limbo" width="360" />
</p>

# <p align="center"><sub>**_Lidarr Tools | Downloader | Data Server_**</sub></p>

## Introduction

Limbo is a set of tools and a downloader for Lidarr music manager. It contains a full MusicBrainz mirror server with automated installation. When the Limbo Stick helper is installed next to Lidarr, many settings are auto-discovered, so you don't need to set any URLs, API keys or ports. You can start using Limbo right away.

**Currently implemented features:**

- Library Statistics
- Release blocking (block specific media formats: vinyl, tape, etc.)
- Release / Artist refreshing (paste URL/ID single/bulk and refresh albums/artists)
- Artist Photos, Cover Art + Data providers selection, with drag & drop precedence
- Lidarr control API - start/stop/restart/update Lidarr, cancel/pause scheduler tasks
- Lidarr theme system with over 30 themes
- SMB network browser and path mounting - no env files to edit

**Features in testing:**

- Automated / Manual Downloads - built-in downloader or use your own external client (SLSKD)
- Manual bulk importing
- Release / Album splitting - manage and download Original and Deluxe, Anniversary (etc.) releases
- One-shot bulk artwork search with direct Lidarr installation
- CSV / JSON Lidarr data export and custom reporting

Other features are currently in development or testing. Update notifications are displayed at the bottom of the Limbo WebUI.

<p align="center">
  <img src="https://github.com/HVR88/Docs-Extras/blob/master/limbo-info-screen.png?raw=true" alt="Limbo" width="600" />
</p>

## Requirements

- Linux server or VM or LXC with Docker
- 300-400 GB of available storage (400-500 GB recommended)
  - Additional storage for optional downloading and music sharing
- 8 GB of memory available to the container (16GB+ recommended)
- 2-4 hours installation time

## Quick Start

### 1. Register for MusicBrainz access & token

- Create an account at https://MusicBrainz.com
- Get your _Live Data Feed Access Token_ from Metabrainz https://metabrainz.org/profile

### 2. Download the Limbo compose files (no git required)

Create a folder and download the latest `compose.yaml` and `example.env`
from the Limbo release assets (or the raw files in this repo).

```bash
mkdir -p /opt/docker/limbo
cd /opt/docker/limbo
curl -fsSL -o limbo-latest.zip https://github.com/HVR88/Limbo/releases/latest/download/limbo-latest.zip
unzip -o limbo-latest.zip
```

### 3. Copy and configure env file

Copy `example.env` to `.env`, and edit the top section before first run:

```bash
cp example.env .env
```

Configure this variable in the .env file:

- Set **`MUSICBRAINZ_REPLICATION_TOKEN`** (get from https://metabrainz.org/profile)

> [!TIP]
>
> When deploying from a terminal, use _screen_ or _tmux_ so the compose process can continue running if your session drops (closing the window, computer goes to sleep, etc.)

### 4. Download containers, build DB & start up (!) _This takes 2-4 hours_

```
docker compose up -d
```

### 5. Install Limbo Stick next to Lidarr

On your Lidarr host or Docker platform, install the Limbo Stick container next to Lidarr.

While Limbo itself can be installed on any host and doesn't need to be next to Lidarr, the special Limbo Stick container does. It's a helper that allows Limbo direct control over Lidarr's environment, to add theme support, built-in download buttons and the ability to start/stop/pause tasks.

## Wrap-Up

You can monitor the progress of the long first-time installation jobs from another terminal:

```
docker compose logs -f --timestamps
```

Or with less "noise:"

```
docker compose logs -f --no-log-prefix --tail=200 \
  bootstrap search-bootstrap search musicbrainz indexer indexer-cron limbo

```

## Browser Access

- **Limbo** web UI: **http://HOST_IP:4808**

- **MusicBrainz** local web site: **http://HOST_IP:4820**
  <br>(Off by default, enable it in Limbo General Settings)

- **Limbo Stick Status** web page: **http://HOST_IP:4810**

> [!TIP]
>
> Put a reverse proxy (NPM, Caddy, Traefik, SWAG) in front of your host IP and use your own domain to reach Limbo and MusicBrainz locally on port 80 (HTTP) or 443 (HTTPS) example: limbo.domain.net and mbrainz.domain.net

### Updating

Pull the latest images and restart two times (the first time installs updated compose file, second time uses the updatec file to put up the containers):

```
docker compose pull
docker compose up -d
docker compose up -d
```

If you have any issues with stale containers, then do this instead:

```
sudo docker compose pull
sudo docker compose up -d
sudo docker compose pull
sudo docker compose up -d --remove-orphans --force-recreate
```

The `.env` file is user-maintained and won't be changed when updating. Updating will refresh all other managed files automatically: admin scripts, compose template, and defaults, including _example.env._

You should look in the _`example.env`_ file for any changes that may need to be applied to `.env` - if there are new required variables, you should get a warning on the second compose up.

These files are automatically updated on every _docker compose up_

- `compose.yaml`
- `example.env`
- `README.md`

## Limbo Configuration

Go to **http://<your_LIMBO_IP>:4808**

Use the SETTINGS button on the top right of the webUI to configure your Lidarr IP address, port and API KEY. The API Key can be found in Lidarr's **Settings -> General** page

## Notes

- _Continued (scheduled) replication and indexing is required to keep the database up-to-date and at optimal performance - this is already active by default_
- This stack is configured for private use on a LAN, behind a firewall, **IT'S NOT SECURED FOR THE OPEN INTERNET**

## Maintenance

Keep database scheduled tasks and mainenance options enabled in Limbo Settings.

Additional helper scripts are synced into `admin/` automatically when the stack starts or updates:

- `admin/status` (show container status)
- `admin/logs [services...]` (follow logs)
- `admin/restart [services...]` (restart services)
- `admin/replicate-now` (trigger replication immediately)
- `admin/reindex-now` (trigger search reindex)
- `admin/bootstrap-reset` (clear bootstrap markers; prompts for confirmation)
