#!/usr/bin/env bash

# Validate the Nix provisioning adapters: parse every .nix file, then
# evaluate them against the real nix-darwin / home-manager / NixOS
# option schemas via tests/nix/eval.nix.
#
# Requires nix-instantiate and network access (pinned tarballs are
# fetched on first run). scripts/validate.sh calls this and skips with
# a warning when nix-instantiate is unavailable.

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if ! command -v nix-instantiate >/dev/null 2>&1; then
    printf "error: nix-instantiate not found\n" >&2
    exit 1
fi

find . -type f -name '*.nix' -not -path './.git/*' -exec nix-instantiate --parse {} \; >/dev/null
printf "OK nix parse\n"

nix-instantiate --eval --strict tests/nix/eval.nix >/dev/null
printf "OK nix eval (nix-darwin, home-manager, nixos option schemas)\n"
