#!/bin/bash

# shellcheck source=/dev/null

# Omarchy Preferences Configuration
#
# This configuration sets up preferences for Omarchy
# (https://github.com/basecamp/omarchy), DHH's Arch Linux + Hyprland
# desktop distro.
#
# Deliberately does not call into ../colorschemes the way arch/arch.sh
# does for generic Arch+GNOME setups: Omarchy ships its own theme
# system (Setup > Theme), so applying the generic colorschemes here
# would fight with it. For the same reason there is no home-manager.nix
# mirror in this directory -- Omarchy doesn't use Nix.
#
# @author Nicholas Adamou

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" || exit

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    # Hyprland cursor size
    bash cursor-size.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Waybar clock format
    bash clock-format.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    echo "Omarchy preferences configuration complete"

}

main
