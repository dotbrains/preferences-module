#!/bin/bash
#
# Sets the Hyprland cursor size (XCURSOR_SIZE/HYPRCURSOR_SIZE) for Omarchy.
# Ported from
# https://github.com/nicholasadamou/omarchy-scripts/blob/master/hyprland/set-cursor-size.sh
# (idempotent: safe to re-run, applies immediately if Hyprland is running).

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
CURSOR_SIZE="${1:-16}"  # Default to 16 if not specified
HYPR_CONFIG_DIR="${HOME}/.config/hypr"
ENVS_CONF="${HYPR_CONFIG_DIR}/envs.conf"
AUTOSTART_CONF="${HYPR_CONFIG_DIR}/autostart.conf"

echo -e "${GREEN}=== Hyprland Cursor Size Configuration ===${NC}\n"

# Validate cursor size
if ! [[ "$CURSOR_SIZE" =~ ^[0-9]+$ ]] || [ "$CURSOR_SIZE" -lt 8 ] || [ "$CURSOR_SIZE" -gt 64 ]; then
    echo -e "${RED}Error: Cursor size must be a number between 8 and 64${NC}"
    echo -e "Usage: $0 [size]"
    echo -e "Example: $0 16"
    exit 1
fi

echo -e "${YELLOW}Setting cursor size to: ${CURSOR_SIZE}${NC}\n"

# Check if Hyprland config directory exists
if [ ! -d "$HYPR_CONFIG_DIR" ]; then
    echo -e "${RED}Error: Hyprland config directory not found at ${HYPR_CONFIG_DIR}${NC}"
    exit 1
fi

# Get current cursor theme
CURSOR_THEME=$(gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null | tr -d "'")
if [ -z "$CURSOR_THEME" ]; then
    CURSOR_THEME="Bibata-Modern-Classic"  # Omarchy default
    echo -e "${YELLOW}⚠ Could not detect cursor theme, using default: ${CURSOR_THEME}${NC}"
fi

# Configure envs.conf
echo -e "${YELLOW}Configuring ${ENVS_CONF}...${NC}"

if [ ! -f "$ENVS_CONF" ]; then
    echo -e "${YELLOW}Creating ${ENVS_CONF}...${NC}"
    cat > "$ENVS_CONF" << EOF
# Extra env variables
# env = MY_GLOBAL_ENV,setting

# Cursor size (override Omarchy defaults)
env = XCURSOR_SIZE,${CURSOR_SIZE}
env = HYPRCURSOR_SIZE,${CURSOR_SIZE}
EOF
else
    # Remove existing cursor size settings
    sed -i '/^env = XCURSOR_SIZE,/d' "$ENVS_CONF"
    sed -i '/^env = HYPRCURSOR_SIZE,/d' "$ENVS_CONF"

    # Add new cursor size settings
    if ! grep -q "# Cursor size" "$ENVS_CONF"; then
        cat >> "$ENVS_CONF" << EOF

# Cursor size (override Omarchy defaults)
env = XCURSOR_SIZE,${CURSOR_SIZE}
env = HYPRCURSOR_SIZE,${CURSOR_SIZE}
EOF
    else
        # Replace the cursor size values if the section exists
        sed -i "/# Cursor size/a env = XCURSOR_SIZE,${CURSOR_SIZE}\\nenv = HYPRCURSOR_SIZE,${CURSOR_SIZE}" "$ENVS_CONF"
    fi
fi
echo -e "${GREEN}✓ Updated ${ENVS_CONF}${NC}"

# Configure autostart.conf
echo -e "${YELLOW}Configuring ${AUTOSTART_CONF}...${NC}"

if [ ! -f "$AUTOSTART_CONF" ]; then
    echo -e "${YELLOW}Creating ${AUTOSTART_CONF}...${NC}"
    cat > "$AUTOSTART_CONF" << EOF
# Extra autostart processes
# exec-once = uwsm-app -- my-service

# Set cursor size
exec-once = hyprctl setcursor ${CURSOR_THEME} ${CURSOR_SIZE}
EOF
else
    # Remove existing cursor size settings
    sed -i '/^exec-once = hyprctl setcursor/d' "$AUTOSTART_CONF"

    # Add new cursor size setting
    if ! grep -q "# Set cursor size" "$AUTOSTART_CONF"; then
        cat >> "$AUTOSTART_CONF" << EOF

# Set cursor size
exec-once = hyprctl setcursor ${CURSOR_THEME} ${CURSOR_SIZE}
EOF
    else
        # Replace the cursor size command if the section exists
        sed -i "/# Set cursor size/a exec-once = hyprctl setcursor ${CURSOR_THEME} ${CURSOR_SIZE}" "$AUTOSTART_CONF"
    fi
fi
echo -e "${GREEN}✓ Updated ${AUTOSTART_CONF}${NC}"

# Apply immediately if Hyprland is running
if pgrep -x "Hyprland" > /dev/null; then
    echo -e "\n${YELLOW}Applying cursor size immediately...${NC}"
    if hyprctl setcursor "$CURSOR_THEME" "$CURSOR_SIZE" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Cursor size applied${NC}"
    else
        echo -e "${YELLOW}⚠ Could not apply immediately, changes will take effect on next login${NC}"
    fi
else
    echo -e "\n${YELLOW}⚠ Hyprland is not running, changes will take effect on next login${NC}"
fi

echo -e "\n${GREEN}=== Configuration Complete ===${NC}"
echo -e "Cursor size has been set to ${CURSOR_SIZE}"
echo -e "\nTo apply changes:"
echo -e "  - Log out and log back in to Hyprland"
echo -e "  - Or run: hyprctl setcursor ${CURSOR_THEME} ${CURSOR_SIZE}"
