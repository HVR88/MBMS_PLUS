#!/bin/sh

set -eu

log() {
  echo "[search-bootstrap] $*"
}

MODE="${MUSICBRAINZ_BOOTSTRAP_SEARCH_INDEXES:-download}"
DB_MARKER="${MUSICBRAINZ_BOOTSTRAP_DB_MARKER:-/media/dbdump/.bootstrap.db.done}"
WAIT_FOR_DB="${MUSICBRAINZ_BOOTSTRAP_WAIT_FOR_DB:-1}"
MARKER="${MUSICBRAINZ_BOOTSTRAP_SEARCH_MARKER:-/var/cache/musicbrainz/solr-backups/.bootstrap.solr.done}"
CLEANUP="${MUSICBRAINZ_BOOTSTRAP_SOLR_CLEANUP:-0}"
CLEAN_MARKERS="${MUSICBRAINZ_BOOTSTRAP_CLEAN_MARKERS:-0}"

if [ "$CLEAN_MARKERS" = "1" ]; then
  log "Cleaning search bootstrap marker."
  rm -f "$MARKER"
  exit 0
fi

case "$MODE" in
  0|off|skip|false|no)
    log "Search index bootstrap disabled (MUSICBRAINZ_BOOTSTRAP_SEARCH_INDEXES=$MODE)."
    exit 0
    ;;
  download|prebuilt)
    ;;
  *)
    log "Unknown MUSICBRAINZ_BOOTSTRAP_SEARCH_INDEXES=$MODE (expected download/prebuilt or skip)."
    exit 1
    ;;
 esac

if [ "$WAIT_FOR_DB" = "1" ] && [ -n "$DB_MARKER" ]; then
  while [ ! -f "$DB_MARKER" ]; do
    log "Waiting for database bootstrap marker at $DB_MARKER ..."
    sleep 30
  done
fi

if [ -f "$MARKER" ]; then
  log "Search marker exists at $MARKER, skipping."
  exit 0
fi

if ! command -v fetch-backup-archives >/dev/null 2>&1; then
  log "fetch-backup-archives not found in image."
  exit 1
fi
if ! command -v load-backup-archives >/dev/null 2>&1; then
  log "load-backup-archives not found in image."
  exit 1
fi

BACKUP_DIR_CACHE="/var/cache/musicbrainz/solr-backups"
BACKUP_DIR_SOLR="/var/solr/solr-backups"

mkdir -p "$BACKUP_DIR_CACHE"
if [ ! -e "$BACKUP_DIR_SOLR" ]; then
  ln -s "$BACKUP_DIR_CACHE" "$BACKUP_DIR_SOLR"
elif [ -d "$BACKUP_DIR_SOLR" ] && [ -z "$(ls -A "$BACKUP_DIR_SOLR" 2>/dev/null)" ]; then
  rmdir "$BACKUP_DIR_SOLR" || true
  ln -s "$BACKUP_DIR_CACHE" "$BACKUP_DIR_SOLR"
fi

export SOLR_BACKUP_DIR="$BACKUP_DIR_CACHE"
export SOLR_BACKUP_ARCHIVE_DIR="$BACKUP_DIR_CACHE"

SOLR_STARTED=0
if command -v solr >/dev/null 2>&1; then
  SOLR_HOME_DIR="${SOLR_HOME:-/var/solr/data}"
  mkdir -p "$SOLR_HOME_DIR"
  export SOLR_HOME="$SOLR_HOME_DIR"
  if command -v curl >/dev/null 2>&1; then
    if ! curl -fsS http://localhost:8983/solr/admin/info/system >/dev/null 2>&1; then
      log "Starting temporary Solr instance for bootstrap."
      solr start -c -p 8983 -s "$SOLR_HOME_DIR"
      SOLR_STARTED=1
    fi
  else
    log "curl not found; starting temporary Solr instance for bootstrap."
    solr start -c -p 8983 -s "$SOLR_HOME_DIR"
    SOLR_STARTED=1
  fi
fi

log "Downloading prebuilt search indexes (this is large)."
fetch-backup-archives

log "Loading prebuilt search indexes."
load-backup-archives

if [ "$CLEANUP" = "1" ] && command -v remove-backup-archives >/dev/null 2>&1; then
  log "Removing downloaded Solr backup archives."
  remove-backup-archives
fi

if [ "$SOLR_STARTED" = "1" ]; then
  log "Stopping temporary Solr instance."
  solr stop -p 8983
fi

mkdir -p "$(dirname "$MARKER")"
touch "$MARKER"
log "Search index bootstrap complete."
