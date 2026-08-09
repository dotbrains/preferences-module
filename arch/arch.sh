#!/bin/bash

# shellcheck source=/dev/null

# Arch Linux Preferences Configuration
#
# This configuration sets up preferences and configurations for Arch Linux
# system settings and applications.
#
# @author Nicholas Adamou

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" || exit

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    # Desktop Environment preferences (GNOME)
    #
    # Mirrors the macOS choices in macos/system/keyboard.sh and
    # macos/system/trackpad.sh. Declarative mirror: home-manager.nix
    # (dconf.settings) in this directory.
    if command -v gsettings >/dev/null 2>&1 && [ -n "${DBUS_SESSION_BUS_ADDRESS:-}${DISPLAY:-}" ]; then
        # Fast key repeat with a short initial delay
        # (macOS: InitialKeyRepeat 20 ~= 300ms, KeyRepeat 1 ~= 15ms)
        gsettings set org.gnome.desktop.peripherals.keyboard delay 300
        gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 15

        # Tap to click and corner-area secondary click
        # (macOS: TrackpadRightClick, TrackpadCornerSecondaryClick)
        gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
        gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'
    else
        echo "gsettings unavailable or no desktop session; skipping GNOME preferences"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # System preferences
    # TODO: Add system-level preferences

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Application preferences
    # TODO: Add application-specific preferences

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Colorschemes
    bash ../colorschemes/arch/gruvbox.sh
    # bash ../colorschemes/nord.sh
    # bash ../colorschemes/catppuccin.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    echo "Arch Linux preferences configuration complete"

}

main
