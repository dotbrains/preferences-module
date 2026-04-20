#!/bin/bash

# shellcheck source=/dev/null

# macOS Preferences Configuration
#
# This configuration applies to the latest version of macOS,
# and sets up preferences and configurations for all the built-in services and
# apps. Third-party app config should be done elsewhere.
#
# If you want to figure out what default needs changing, do the following:
#
#   1. `cd /tmp`
#   2. Store current defaults in file: `defaults read > before`
#   3. Make a change to your system.
#   4. Store new defaults in file: `defaults read > after`
#   5. Diff the files: `diff before after`
#
# @see: http://secrets.blacktree.com/?showapp=com.apple.finder
# @see: https://github.com/herrbischoff/awesome-macos-command-line
#
# @author Nicholas Adamou

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" || exit

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    # Close any open `System Preferences` panes in order to
    # avoid overriding the preferences that are being changed.

    ./close_system_preferences_panes.applescript 2>/dev/null || true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # App preferences

    # Apple Apps
    ./apps/terminal/terminal.sh
    ./apps/app_store.sh
    ./apps/finder.sh
    ./apps/activity_monitor.sh
    ./apps/messages.sh
    ./apps/mail.sh
    ./apps/safari.sh
    ./apps/maps.sh
    ./apps/photos.sh
    ./apps/textedit.sh

    # Third-party Apps
    # TODO: Add third-party apps here

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # System preferences

    ./system/screen.sh
    # spotlight preferences causes:
    # 2021-11-13 16:29:36.097 defaults[52324:117295] Could not write domain /.Spotlight-V100/VolumeConfiguration; exiting
    # ./system/spotlight.sh
    ./system/dashboard.sh
    ./system/dock.sh
    ./system/keyboard.sh
    ./system/trackpad.sh
    ./system/language_and_region.sh
    ./system/ui_and_ux.sh
    ./system/security.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Colorschemes

    bash ../colorschemes/macos/gruvbox.sh
    # bash ../colorschemes/nord.sh
    # bash ../colorschemes/catppuccin.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    success "macOS preferences setup complete"

}

main
