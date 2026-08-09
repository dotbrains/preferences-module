# NixOS adapter for universal.sh, mirrored 1:1.
#
# On NixOS hosts preferences.sh falls through to universal.sh (the
# arch/ and debian/ paths are distro-specific), and universal.sh
# currently defines no preferences (its body is a TODO), so this module
# intentionally declares nothing. When a preference is added to the
# script, add its declarative mirror here.
#
# Typical homes for system-level preferences on NixOS:
#   services.*   - system services and desktop environment settings
#   programs.*   - system-wide program configuration

{ ... }:

{
}
