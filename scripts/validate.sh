#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

./tests/main.sh
find macos arch debian universal -type f -name '*.sh' -exec bash -n {} +
