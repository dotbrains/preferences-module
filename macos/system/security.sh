#!/bin/bash

source "$HOME/set-me-up/dotfiles/utilities/import.sh"

smu::import base

ask_for_sudo

# Customize Security & Privacy Settings in macOS:

# Use Touch ID to authenticate sudo commands
# https://apple.stackexchange.com/a/466029

# Check if /etc/pam.d/sudo_local exists, create it from the template if it doesn't
if [ ! -f /etc/pam.d/sudo_local ]; then
    sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
fi

# Check if the line is already uncommented in /etc/pam.d/sudo_local
if ! grep -q "^auth" /etc/pam.d/sudo_local; then
    sudo sed -i '' "s/^#auth/auth/" /etc/pam.d/sudo_local
fi

echo "Updated /etc/pam.d/sudo_local to use Touch ID for sudo commands."
