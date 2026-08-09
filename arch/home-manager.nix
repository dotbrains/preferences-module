# home-manager adapter for arch.sh, mirrored 1:1.
#
# arch.sh currently defines no preferences (its body is TODOs; the
# colorscheme delegation is owned by the separate colorschemes module),
# so this module intentionally declares nothing. When a preference is
# added to the script, add its declarative mirror here.
#
# Typical homes for Linux desktop preferences (the equivalents of the
# macOS system.defaults options used by macos/nix-darwin.nix):
#   dconf.settings   - GNOME / GTK preferences (gsettings)
#   xdg.configFile   - arbitrary ~/.config files (KDE, i3, etc.)
#   gtk.*            - GTK theme and font settings

{ ... }:

{
}
