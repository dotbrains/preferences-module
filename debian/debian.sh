#!/bin/bash

# shellcheck source=/dev/null

# Debian Preferences Configuration
#
# This configuration sets up preferences and configurations for Debian
# system settings and applications.
#
# @author Nicholas Adamou

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" || exit

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    # Desktop Environment preferences
    # TODO: Add DE-specific preferences (GNOME, KDE, XFCE, etc.)

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # System preferences
    # TODO: Add system-level preferences

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Application preferences
    # TODO: Add application-specific preferences

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Colorschemes
    bash ../colorschemes/universal/gruvbox.sh
    # bash ../colorschemes/nord.sh
    # bash ../colorschemes/catppuccin.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    echo "Debian preferences configuration complete"

}

main
