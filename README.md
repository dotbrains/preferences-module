# 'preferences' Module ⚙️

[![Lint](https://github.com/smeltery/preferences-module/actions/workflows/lint.yml/badge.svg)](https://github.com/smeltery/preferences-module/actions/workflows/lint.yml)
[![Tests](https://github.com/smeltery/preferences-module/actions/workflows/tests.yml/badge.svg)](https://github.com/smeltery/preferences-module/actions/workflows/tests.yml)
[![License: PolyForm Shield 1.0.0](https://img.shields.io/badge/License-PolyForm%20Shield%201.0.0-blue.svg)](https://polyformproject.org/licenses/shield/1.0.0)

Multi-OS system preferences configuration with support for macOS, Omarchy, Arch Linux, and Debian.

## Structure

```text
preferences/
├── macos/                  # macOS-specific preferences
│   ├── macos.sh           # Entry point for macOS
│   ├── apps/              # Application preferences
│   │   ├── terminal/
│   │   ├── finder.sh
│   │   ├── safari.sh
│   │   ├── mail.sh
│   │   └── ...
│   ├── system/            # System preferences
│   │   ├── dock.sh
│   │   ├── keyboard.sh
│   │   ├── trackpad.sh
│   │   └── ...
│   └── close_system_preferences_panes.applescript
├── omarchy/                # Omarchy-specific preferences
│   ├── omarchy.sh          # Entry point for Omarchy
│   ├── cursor-size.sh      # Hyprland cursor size
│   └── clock-format.sh     # Waybar 12-hour clock
├── arch/                  # Arch Linux-specific preferences
│   └── arch.sh
├── debian/                # Debian-specific preferences
│   └── debian.sh
├── universal/             # Cross-platform preferences
│   └── universal.sh
└── preferences.sh         # Entry point with OS detection
```

## Supported Operating Systems

### macOS

- **Supported Versions:** macOS Sonoma (14.5) and newer
- **Applications:** Terminal, Finder, Safari, Mail, Messages, Photos, TextEdit, Activity Monitor, Maps, App Store
- **System Settings:** Dock, Keyboard, Trackpad, Screen, Dashboard, Language & Region, UI/UX, Security

### Omarchy

- **Hyprland:** Cursor size (`XCURSOR_SIZE`/`HYPRCURSOR_SIZE`, applied immediately if Hyprland is running)
- **Waybar:** 12-hour clock format
- Deliberately does not touch theming/colorschemes — Omarchy ships its own theme system (Setup > Theme)
- Ported from [nicholasadamou/omarchy-scripts](https://github.com/nicholasadamou/omarchy-scripts)

### Arch Linux

- Desktop environment preferences (to be configured)
- System-level preferences (to be configured)

### Debian/Ubuntu

- Desktop environment preferences (to be configured)
- System-level preferences (to be configured)

## Install

Download, review, then execute the script:

```bash
source /dev/stdin <<<"$(curl -s "https://raw.githubusercontent.com/smeltery/preferences-module/master/preferences.sh")"
```

It should take a few minutes to install.

## Usage

### Quick Start

The script automatically detects your OS and applies the appropriate preferences:

```bash
bash preferences.sh
```

### OS-Specific Usage

**macOS only:**

```bash
bash macos/macos.sh
```

**Omarchy only:**

```bash
bash omarchy/omarchy.sh
```

**Arch Linux only:**

```bash
bash arch/arch.sh
```

**Debian only:**

```bash
bash debian/debian.sh
```

**Universal (cross-platform) only:**

```bash
bash universal/universal.sh
```

## How It Works

### Entry Point Flow

1. `preferences.sh` detects your OS using utilities functions (`is_macos`,
   `is_omarchy`, `is_arch_linux`, `is_debian`) — `is_omarchy` is checked
   before `is_arch_linux` since Omarchy is Arch-based and would otherwise
   match the generic Arch branch
2. Routes to appropriate OS-specific script
3. OS-specific script applies all relevant preferences for that platform

### Adding New Preferences

**For macOS:**

1. Create new script in `macos/apps/` or `macos/system/`
2. Make it executable: `chmod +x <script>.sh`
3. Add call to `macos/macos.sh`

**For Omarchy/Arch/Debian:**

1. Create preference scripts in respective OS directory
2. Make executable and add to the OS-specific entry script

**For Universal:**

1. Add cross-platform configurations to `universal/universal.sh`

### Nix Provisioning (nix-darwin)

The macOS preferences are also available declaratively for blueprints
using `mode = "nix"` or `mode = "hybrid"` with the `nix-darwin` adapter.
Each `nix-darwin.nix` file mirrors its shell-script counterpart 1:1:

- `macos/nix-darwin.nix` — aggregate (imports system and apps)
- `macos/system/nix-darwin.nix` — dock, keyboard, trackpad,
  screenshots, language, UI/UX, Touch ID for sudo
- `macos/apps/nix-darwin.nix` — Finder, Safari, App Store, Activity
  Monitor, Messages, Mail, Maps, Photos, TextEdit
- `macos/apps/terminal/nix-darwin.nix` — Terminal

Typed `system.defaults` options are used where nix-darwin provides
them; other domains go through `system.defaults.CustomUserPreferences`,
and the few imperative leftovers (host name, ByHost domains, PlistBuddy
edits of nested Finder plist keys) run as activation scripts.

Requirements and caveats:

- nix-darwin 25.05 or newer, with `system.primaryUser` set by the
  blueprint
- Safari preferences require Full Disk Access for the terminal running
  `darwin-rebuild` (the same constraint applies to `safari.sh`)
- The shell scripts remain the source of truth for rcm mode; when
  changing a preference, update both the script and its Nix mirror

### Nix Provisioning (Linux)

Linux blueprints get the same treatment through the `home-manager` and
`nixos` adapters:

- `arch/home-manager.nix` — mirrors `arch.sh`
- `debian/home-manager.nix` — mirrors `debian.sh` (home-manager runs
  standalone on Debian/Ubuntu)
- `universal/home-manager.nix` and `universal/nixos.nix` — mirror
  `universal.sh` (NixOS hosts fall through to the universal
  preferences, matching `preferences.sh` routing)

`omarchy/` has no Nix mirror: Omarchy doesn't use Nix, so there's no
declarative adapter to keep in sync for it.

The arch and debian scripts apply GNOME preferences via `gsettings`
(keyboard repeat and touchpad behavior, mirroring the macOS choices),
and their `home-manager.nix` files carry the same settings as
`dconf.settings`. `universal.sh` currently contains no preferences, so
its Nix mirrors declare nothing yet. The Linux equivalents of the macOS
`system.defaults` options are `dconf.settings` (GNOME/gsettings),
`xdg.configFile` (KDE, i3, XFCE), and `gtk.*` in home-manager. The same
rule applies: when adding a preference to a script, add its declarative
mirror to the matching Nix file.

All Nix adapters are gated in CI: `scripts/validate-nix.sh` parses
every `.nix` file and evaluates the modules against the real
nix-darwin, home-manager, and NixOS option schemas
(`tests/nix/eval.nix`).

### Adding New OS Support

1. Create new directory: `fedora/`, `opensuse/`, etc.
2. Create OS-specific entry script: `fedora/fedora.sh`
3. Update `preferences.sh` with OS detection logic
4. Implement OS-specific preferences

## Benefits

✅ **Multi-OS support**: Works across macOS, Omarchy, Arch Linux, and Debian

✅ **Clear separation**: OS-specific configurations are isolated

✅ **Safe to run multiple times**: Scripts are idempotent

✅ **Extensible**: Easy to add new OSes or preferences

✅ **Maintainable**: Organized structure for easy updates

## Requirements

This script requires the [smeltery/utilities](https://github.com/smeltery/utilities) functions for OS detection and
common operations.

## License

Licensed under [PolyForm Shield 1.0.0](https://polyformproject.org/licenses/shield/1.0.0).
See [LICENSE](LICENSE) for details.
