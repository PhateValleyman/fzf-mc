# fzf-mc — Roadmap

## v0.1.x — Core Foundation

**Stav:** ✅ vytvořena základní kostra

- loader modulů (`lib/core.sh`)
- konfigurace (`config/config.conf`)
- UI základ (`lib/ui.sh`)
- panelový model (aktivní/neaktivní panel, přepínání Tab)
- preview API (`lib/preview.sh`)

## v0.2.0 — File Operations

**Cíl:** plnohodnotná práce se soubory.

Funkce (`lib/files.sh`):

```
copy()
move()
delete()
mkdir()
rename()
```

Přidat:

- potvrzení operací (`utils::confirm`)
- progress (u `rclone`/`scp` přenosů)
- ochranu proti omylem smazání (`USE_TRASH`, koš v `data/trash`)

## v0.3.0 — SSH Integration

**Cíl:** práce s NAS a servery.

Funkce (`lib/ssh.sh`, `backends/ssh.sh`):

- SSH panel
- SSH profily (`profiles/*.conf`)
- SCP
- SFTP

Profil:

```
name=ZyXEL NSA320
host=192.168.1.20
user=root
```

## v0.4.0 — rclone Integration

**Cíl:** cloud jako další disk.

Podpora:

```
rclone://gdrive
rclone://backup
```

Funkce:

- mount
- browsing
- upload
- download

## v0.5.0 — Plugin System

**Cíl:** rozšiřitelnost.

Plugin API:

```
plugin_init()
plugin_menu()
plugin_action()
```

Příklady:

```
plugins/
├── android.sh
├── magisk.sh
├── media.sh
├── git.sh
└── docker.sh
```

## v0.6.0 — SQLite Database

**Cíl:** inteligentní historie.

Databáze: `database/fzf-mc.db`

Tabulky:

- **history** — `path`, `timestamp`, `backend`
- **tags** — `file`, `tag`, `note`
- **operations** — `action`, `source`, `destination`, `time`

Funkce:

- historie cest
- oblíbené složky
- tagování
- rychlé vyhledávání
