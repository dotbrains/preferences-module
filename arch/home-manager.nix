# home-manager adapter for arch.sh, mirrored 1:1.
#
# Each setting mirrors a gsettings call in arch.sh; when changing a
# preference, update both the script and this mirror.
#
# Typical homes for further Linux desktop preferences (the equivalents
# of the macOS system.defaults options used by macos/nix-darwin.nix):
#   dconf.settings   - GNOME / GTK preferences (gsettings)
#   xdg.configFile   - arbitrary ~/.config files (KDE, i3, etc.)
#   gtk.*            - GTK theme and font settings

{ lib, ... }:

{
  dconf.settings = {
    # Fast key repeat with a short initial delay
    # (mirrors macos/system/keyboard.sh: InitialKeyRepeat 20, KeyRepeat 1)
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 300;
      repeat-interval = lib.hm.gvariant.mkUint32 15;
    };

    # Tap to click and corner-area secondary click
    # (mirrors macos/system/trackpad.sh)
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      click-method = "areas";
    };
  };
}
