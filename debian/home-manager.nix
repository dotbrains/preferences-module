# home-manager adapter for debian.sh, mirrored 1:1.
#
# home-manager runs standalone on Debian/Ubuntu, so this adapter lets
# nix and hybrid blueprints manage user preferences declaratively on
# those systems.
#
# debian.sh currently defines no preferences (its body is TODOs; the
# colorscheme delegation is owned by the separate colorschemes module),
# so this module intentionally declares nothing. When a preference is
# added to the script, add its declarative mirror here.
#
# Typical homes for Linux desktop preferences (the equivalents of the
# macOS system.defaults options used by macos/nix-darwin.nix):
#   dconf.settings   - GNOME / GTK preferences (gsettings)
#   xdg.configFile   - arbitrary ~/.config files (KDE, XFCE, etc.)
#   gtk.*            - GTK theme and font settings

{ ... }:

{
}
