# 'preferences' Module ⚙️

[![Lint](https://github.com/dotbrains/preferences-module/actions/workflows/lint.yml/badge.svg)](https://github.com/dotbrains/preferences-module/actions/workflows/lint.yml)
[![Tests](https://github.com/dotbrains/preferences-module/actions/workflows/tests.yml/badge.svg)](https://github.com/dotbrains/preferences-module/actions/workflows/tests.yml)

Multi-OS system preferences configuration with support for macOS, Arch Linux, and Debian.

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

### Arch Linux

- Desktop environment preferences (to be configured)
- System-level preferences (to be configured)

### Debian/Ubuntu

- Desktop environment preferences (to be configured)
- System-level preferences (to be configured)

## Install

Download, review, then execute the script:

```bash
source /dev/stdin <<<"$(curl -s "https://raw.githubusercontent.com/dotbrains/preferences-module/master/preferences.sh")"
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

1. `preferences.sh` detects your OS using utilities functions (`is_macos`, `is_arch`, `is_debian`)
2. Routes to appropriate OS-specific script
3. OS-specific script applies all relevant preferences for that platform

### Adding New Preferences

**For macOS:**

1. Create new script in `macos/apps/` or `macos/system/`
2. Make it executable: `chmod +x <script>.sh`
3. Add call to `macos/macos.sh`

**For Arch/Debian:**

1. Create preference scripts in respective OS directory
2. Make executable and add to the OS-specific entry script

**For Universal:**

1. Add cross-platform configurations to `universal/universal.sh`

### Adding New OS Support

1. Create new directory: `fedora/`, `opensuse/`, etc.
2. Create OS-specific entry script: `fedora/fedora.sh`
3. Update `preferences.sh` with OS detection logic
4. Implement OS-specific preferences

## Benefits

✅ **Multi-OS support**: Works across macOS, Arch Linux, and Debian

✅ **Clear separation**: OS-specific configurations are isolated

✅ **Safe to run multiple times**: Scripts are idempotent

✅ **Extensible**: Easy to add new OSes or preferences

✅ **Maintainable**: Organized structure for easy updates

## Requirements

This script requires the [dotbrains/utilities](https://github.com/dotbrains/utilities) functions for OS detection and
common operations.

## License

Licensed under [PolyForm Shield 1.0.0](https://polyformproject.org/licenses/shield/1.0.0/).
See [LICENSE](LICENSE) for details.
