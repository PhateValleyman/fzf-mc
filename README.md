# fzf-mc

Moderní terminálový dvoupanelový správce souborů pro Termux / Linux,
kombinující rychlost a UX **fzf**, dvoupanelové ovládání **Midnight
Commander**, filozofii Unixu (malé moduly, pipe) a přístup k lokálním
i vzdáleným úložištím (SSH, rclone/cloud).

- **Repo:** https://github.com/PhateValleyman/fzf-mc
- **Autor:** [PhateValleyman](https://github.com/PhateValleyman)
- **Jazyk:** Bash
- **Licence:** TBD
- **Primární prostředí:** Termux (Android) / Linux
- **Inspirace:** Midnight Commander, fzf, ranger, nnn

```
fzf + MC + VFS + SSH + rclone
```

## Cíl projektu

- dvoupanelové ovládání jako Midnight Commander
- rychlé fuzzy vyhledávání pomocí fzf
- unixová filozofie (pipe, malé moduly)
- podpora lokálních i vzdálených úložišť (SSH, rclone)
- rozšiřitelný plugin systém

## Instalace

```bash
git clone https://github.com/PhateValleyman/fzf-mc.git
cd fzf-mc
chmod +x fzf-mc.sh
./fzf-mc.sh
```

### Závislosti

| Povinné | Doporučené (volitelné)               |
|---------|----------------------------------------|
| bash ≥4 | bat (syntax-highlight preview)         |
| fzf     | rsync, ssh, scp (SSH backend)          |
|         | rclone (cloud backend)                  |
|         | sqlite3 (historie/tagy — jinak no-op)  |

Na Termuxu:

```bash
pkg install fzf bat openssh rsync rclone sqlite
```

## Použití

```bash
./fzf-mc.sh                 # spustí s výchozí konfigurací (config/config.conf)
./fzf-mc.sh --config FILE   # vlastní konfigurace
./fzf-mc.sh --version
./fzf-mc.sh --help
```

## Klávesové ovládání

| Klávesa   | Funkce         |
|-----------|----------------|
| Enter     | otevřít        |
| Backspace | zpět           |
| Tab       | změna panelu   |
| F3        | preview        |
| F4        | edit           |
| F5        | copy           |
| F6        | move           |
| F7        | mkdir          |
| F8        | delete         |
| F9        | menu           |
| F10       | exit           |

## Podporované backendy

### Local filesystem

```
/data/data/com.termux/files/home
/sdcard
/tmp
```

### SSH backend

```
ssh://root@192.168.1.20
```

Primární profil: `profiles/zyxel-nsa320.conf` (ZyXEL NSA320 NAS).
Podporuje SSH připojení, SCP/SFTP přenosy, vzdálené procházení a
kopírování mezi panely. Vždy autentizace klíčem (`~/.ssh/server`),
nikdy heslem.

### rclone backend

```
rclone://remote/path
```

Plán: Google Drive, Dropbox, OneDrive a další rclone remotes — cloud
jako další "disk" v panelu.

## Architektura

```
fzf-mc/
│
├── fzf-mc.sh
├── README.md
├── ROADMAP.md
├── LICENSE
├── .gitignore
│
├── config/
│   └── config.conf
│
├── lib/
│   ├── core.sh
│   ├── ui.sh
│   ├── menu.sh
│   ├── navigation.sh
│   ├── preview.sh
│   ├── files.sh
│   ├── ssh.sh
│   ├── rclone.sh
│   ├── plugins.sh
│   ├── database.sh
│   └── utils.sh
│
├── backends/
│   ├── local.sh
│   ├── ssh.sh
│   └── rclone.sh
│
├── profiles/
│   └── zyxel-nsa320.conf
│
├── plugins/
│   ├── enabled/
│   └── README.md
│
├── themes/
│   └── default.conf
│
├── database/
│   └── fzf-mc.db
│
└── data/
    ├── bookmarks
    └── history
```

## Konfigurace

`config/config.conf`:

```bash
LEFT_PATH=$HOME
RIGHT_PATH=/sdcard

EDITOR=nano
PREVIEW=bat

USE_TRASH=true

DEFAULT_BACKEND=local
```

## Roadmapa

Viz [ROADMAP.md](ROADMAP.md) pro detailní plán verzí v0.1.x–v0.6.0
(Core Foundation → File Operations → SSH → rclone → Plugin System →
SQLite Database).

## Dlouhodobý cíl

```
fzf-mc
│
├── Local files
├── Android root
├── SSH servers
├── NAS
├── Cloud
├── Plugins
└── Database
```

Univerzální terminálový správce souborů pro Termux, Linux a embedded
zařízení.
