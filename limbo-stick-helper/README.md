# Limbo Stick Instructions & Examples

Quick and dirty.

Default API base URL (from compose): `http://localhost:4810`

Tip: start with dry-run, then apply.

## Carrot: API Scope (talk to Lidarr API)

Use this when when you want to give Lidarr a light tickle

What it can do:

- List and filter cancellable commands
- Cancel matching commands
- Filter by task type text (for example `rescan`)
- Work on active API statuses: `queued`, `started`, `starting`, `pending`

### 1) Preview rescan cancels (dry-run)

```bash
curl -sS -X POST "http://localhost:4810/api/run" \
  -H "Content-Type: application/json" \
  -d '{"type_filter":"rescan"}'
```

### 2) Actually cancel rescan tasks

```bash
curl -sS -X POST "http://localhost:4810/api/run/apply" \
  -H "Content-Type: application/json" \
  -d '{"type_filter":"rescan"}'
```

### 3) Useful API-scope options

- Oldest N only:

```bash
curl -sS -X POST "http://localhost:4810/api/run/apply" \
  -H "Content-Type: application/json" \
  -d '{"type_filter":"rescan","last":5}'
```

- Verbose logs:

```bash
curl -sS -X POST "http://localhost:4810/api/run" \
  -H "Content-Type: application/json" \
  -d '{"type_filter":"rescan","verbose":true}'
```

## Stick: DB Scope (direct DB mode)

Use this when API mode if you need to force Lidarr to your will

Turn on DB scope by sending `"db": true`.

What it can do:

- Query and cancel directly from Commands table
- Choose backend with `"db_type"`: `"auto"`, `"sqlite"`, or `"postgres"`
- Control task status set with `"db_status"`:
  - `"queued"` = queued only
  - `"running"` = running only
  - `"any"` = queued + running

### 1) Preview running rescans only (DB mode)

```bash
curl -sS -X POST "http://localhost:4810/api/run" \
  -H "Content-Type: application/json" \
  -d '{"db":true,"db_status":"running","type_filter":"rescan"}'
```

### 2) Cancel queued + running rescans (DB mode apply)

```bash
curl -sS -X POST "http://localhost:4810/api/run/apply" \
  -H "Content-Type: application/json" \
  -d '{"db":true,"db_status":"any","type_filter":"rescan"}'
```

### 3) Force a backend if needed

- SQLite:

```bash
curl -sS -X POST "http://localhost:4810/api/run" \
  -H "Content-Type: application/json" \
  -d '{"db":true,"db_type":"sqlite","db_status":"queued","type_filter":"rescan"}'
```

- Postgres:

```bash
curl -sS -X POST "http://localhost:4810/api/run" \
  -H "Content-Type: application/json" \
  -d '{"db":true,"db_type":"postgres","db_status":"any","type_filter":"rescan"}'
```

## Extra Handy Endpoints

- Health:

```bash
curl -sS "http://localhost:4810/api/health"
```

- Current options:

```bash
curl -sS "http://localhost:4810/api/options"
```

- Last run result:

```bash
curl -sS "http://localhost:4810/api/last"
```

- Full diagnostics snapshot (cross-install validation):

```bash
curl -sS "http://localhost:4810/api/diagnostics"
```

Diagnostics includes:

- Lidarr/About version runtime details
- Derived config folder and image-cache paths
- Active DB location derivation (sqlite or postgres)
- Postgres storage mount/volume path mapping (when postgres is active)
- Compose context derivation and source
- Container identity, mounts, networks, and runtime cache details
- Errors/warnings for failed derivations

- Restart Lidarr container:

```bash
curl -sS -X POST "http://localhost:4810/api/restart" \
  -H "Content-Type: application/json" \
  -d '{}'
```

## Safe Workflow (recommended)

1. Run dry first (`/api/run`).
2. Check matched tasks in response.
3. Run apply (`/api/run/apply`) with same filters.
4. Re-check with `/api/last`.
