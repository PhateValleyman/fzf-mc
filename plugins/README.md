# fzf-mc pluginy

Tento adresář obsahuje dostupné pluginy pro fzf-mc. Plugin je jeden `.sh`
soubor, který definuje tři funkce s prefixem odpovídajícím jménu souboru
(bez přípony `.sh`):

```bash
<jmeno>_plugin_init()    # volá se jednou při startu (core::bootstrap)
<jmeno>_plugin_menu()    # vrátí jednořádkový popis pro F9 menu
<jmeno>_plugin_action()  # spustí se po výběru z F9 -> Pluginy
```

## Aktivace pluginu

Plugin se aktivuje symlinkem (nebo kopií) do `plugins/enabled/`:

```bash
ln -s ../android.sh plugins/enabled/android.sh
```

Po restartu fzf-mc se plugin automaticky načte (`plugins::load_enabled`
v `lib/plugins.sh`) a objeví se v menu F9 → Pluginy.

## Dostupné ukázkové pluginy

| Plugin      | Popis                                                   |
|-------------|----------------------------------------------------------|
| `android.sh`| Rychlé zkratky do `/sdcard`, `/storage/emulated/0`, atd.  |
| `magisk.sh` | Přístup k Magisk modulům na rootovaných zařízeních        |
| `media.sh`  | EXIF náhled a hromadné akce nad mediálními soubory        |
| `git.sh`    | Git status/log pro aktivní adresář panelu                 |
| `docker.sh` | Přehled kontejnerů/volumes na aktivním SSH cíli            |

## Psaní vlastního pluginu

1. Vytvoř `plugins/mujplugin.sh`.
2. Implementuj `mujplugin_plugin_init`, `mujplugin_plugin_menu`,
   `mujplugin_plugin_action` — prefix je přesný název souboru bez `.sh`
   (viz `plugins::load_enabled` v `lib/plugins.sh`: `basename "$f" .sh`).
   Používej v názvu souboru pouze podtržítka, ne pomlčky, ať je prefix
   platný bash identifikátor.
3. Symlinkni do `plugins/enabled/`.
4. V pluginu máš k dispozici všechny globální funkce fzf-mc
   (`ui::*`, `files::*`, `database::*`, `utils::*`, `ssh::_opts`, …).
