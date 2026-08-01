#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

./tests/main.sh
find macos arch debian universal -type f -name '*.sh' -exec bash -n {} +

installer="$repo_root/../../installer/smu.py"
if [ -f "$installer" ]; then
    SMU_MODULE_PATH="$repo_root/.." python3 "$installer" provisioning-adapter validate --json >/dev/null
fi
