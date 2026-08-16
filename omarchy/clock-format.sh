#!/bin/bash
#
# Configures waybar's clock module to use 12-hour time on Omarchy.
# Ported from
# https://github.com/nicholasadamou/omarchy-scripts/blob/master/waybar/set-12hour.sh
# (idempotent: safe to re-run, backs up config.jsonc before editing).

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
WAYBAR_CONFIG="${HOME}/.config/waybar/config.jsonc"
BACKUP_SUFFIX=".bak"

echo -e "${GREEN}=== Waybar 12-Hour Time Configuration ===${NC}\n"

# Check if waybar config exists
if [ ! -f "$WAYBAR_CONFIG" ]; then
    echo -e "${RED}Error: Waybar config not found at ${WAYBAR_CONFIG}${NC}"
    exit 1
fi

echo -e "${YELLOW}Configuring waybar to use 12-hour time format...${NC}"

# Create backup
cp "$WAYBAR_CONFIG" "${WAYBAR_CONFIG}${BACKUP_SUFFIX}"
echo -e "${GREEN}✓ Created backup at ${WAYBAR_CONFIG}${BACKUP_SUFFIX}${NC}"

# Check current format and convert if needed
if grep -q '"%I:%M' "$WAYBAR_CONFIG" || grep -q '{:%I:%M' "$WAYBAR_CONFIG" || grep -q '{:L%I:%M' "$WAYBAR_CONFIG"; then
    echo -e "${GREEN}✓ Already using 12-hour format${NC}"
elif grep -q '"%H:%M"' "$WAYBAR_CONFIG" || grep -q '"%H:%M:%S"' "$WAYBAR_CONFIG"; then
    echo -e "${YELLOW}Found 24-hour format, converting to 12-hour...${NC}"

    # Replace 24-hour format with 12-hour format
    sed -i 's/"%H:%M:%S"/"%I:%M:%S %p"/g' "$WAYBAR_CONFIG"
    sed -i 's/"%H:%M"/"%I:%M %p"/g' "$WAYBAR_CONFIG"
    sed -i 's/{:%H:%M}/{:%I:%M %p}/g' "$WAYBAR_CONFIG"
    sed -i 's/{:L%H:%M}/{:L%I:%M %p}/g' "$WAYBAR_CONFIG"
    sed -i 's/{:%A %H:%M}/{:%A %I:%M %p}/g' "$WAYBAR_CONFIG"
    sed -i 's/{:L%A %H:%M}/{:L%A %I:%M %p}/g' "$WAYBAR_CONFIG"

    echo -e "${GREEN}✓ Converted to 12-hour format${NC}"
elif ! grep -q '"clock"' "$WAYBAR_CONFIG"; then
    echo -e "${RED}✗ Could not find clock configuration${NC}"
    mv "${WAYBAR_CONFIG}${BACKUP_SUFFIX}" "$WAYBAR_CONFIG"
    exit 1
else
    echo -e "${YELLOW}⚠ Could not detect time format, manually updating...${NC}"
    sed -i '/"clock"/,/"format"/ {
        s/"format": *"[^"]*"/"format": "{:L%A %I:%M %p}"/
    }' "$WAYBAR_CONFIG"
    echo -e "${GREEN}✓ Set to 12-hour format${NC}"
fi

# Reload waybar if it's running
if pgrep -x "waybar" > /dev/null; then
    echo -e "\n${YELLOW}Reloading waybar...${NC}"
    pkill -SIGUSR2 waybar 2>/dev/null || {
        echo -e "${YELLOW}⚠ Could not reload waybar automatically${NC}"
        echo -e "${YELLOW}  Please restart waybar manually or log out/in${NC}"
    }
    echo -e "${GREEN}✓ Waybar reloaded${NC}"
else
    echo -e "\n${YELLOW}⚠ Waybar is not running, changes will take effect when it starts${NC}"
fi

echo -e "\n${GREEN}=== Configuration Complete ===${NC}"
echo -e "Waybar has been configured to use 12-hour time format"
echo -e "\nFormat: Hour:Minute AM/PM (e.g., 3:45 PM)"
echo -e "\nBackup saved at: ${WAYBAR_CONFIG}${BACKUP_SUFFIX}"
