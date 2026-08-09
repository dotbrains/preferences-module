# nix-darwin adapter for the macOS preferences module.
#
# Aggregates the system and app preference modules, mirroring what
# macos.sh runs in rcm mode. Individual submodules can also be imported
# directly through their own module.toml adapters; the Nix module
# system deduplicates repeated imports.
#
# Not represented here (mirroring macos.sh):
#   - close_system_preferences_panes.applescript: unnecessary, since
#     nix-darwin writes preferences during activation rather than
#     through the System Preferences UI
#   - spotlight.sh: disabled in macos.sh (fails on modern macOS)
#   - colorschemes: owned by the separate colorschemes module
#
# Requires nix-darwin 25.05+ (`system.primaryUser` must be set by the
# blueprint).

{ ... }:

{
  imports = [
    ./system/nix-darwin.nix
    ./apps/nix-darwin.nix
  ];
}
