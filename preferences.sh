#!/bin/bash

# shellcheck source=/dev/null

# Preferences Configuration
#
# Multi-OS preferences setup with support for:
# - macOS: System preferences, Finder, Dock, Safari, Terminal, etc.
# - Omarchy: Hyprland/waybar preferences
# - Arch Linux: Desktop environment preferences
# - Debian/Ubuntu: GNOME/KDE preferences
# - Universal: Cross-platform application preferences
#
# @author Nicholas Adamou

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source /dev/stdin <<<"$(curl -s "https://raw.githubusercontent.com/dotbrains/utilities/v1.3.0/import.sh")"

smu::import base
smu::import system

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Apply preferences based on OS
    #
    # is_omarchy is checked before is_arch_linux: Omarchy is Arch-based,
    # so an Omarchy machine satisfies both checks, and the more specific
    # one must win.
    if is_macos; then
        action "Applying preferences (macOS)"
        bash "macos/macos.sh"
    elif is_omarchy; then
        action "Applying preferences (Omarchy)"
        bash "omarchy/omarchy.sh"
    elif is_arch_linux; then
        action "Applying preferences (Arch Linux)"
        bash "arch/arch.sh"
    elif is_debian; then
        action "Applying preferences (Debian)"
        bash "debian/debian.sh"
    else
        action "Applying preferences (universal)"
        bash "universal/universal.sh"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    success "Preferences setup complete"

}

main
