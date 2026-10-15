#!/usr/bin/env bash
#
# Sets up opencode on this machine (macOS / Linux) and wires up this workspace.
#
#   - Checks for Node.js / npm
#   - Installs (or updates) the latest opencode-ai globally
#   - Verifies the local opencode.json
#   - Ensures the local .opencode skills/agents folders exist
#
# Usage:
#   ./setup.sh                # install/update opencode and verify the workspace
#   ./setup.sh --skip-install # only verify the workspace, do not install
#
set -euo pipefail

SKIP_INSTALL=0
for arg in "$@"; do
    case "$arg" in
        --skip-install) SKIP_INSTALL=1 ;;
        -h|--help)
            grep '^#' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *)
            echo "Unknown option: $arg" >&2
            exit 1
            ;;
    esac
done

BOLD=$'\033[1m'
CYAN=$'\033[36m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RESET=$'\033[0m'

step() { printf '\n%s==> %s%s\n' "$CYAN$BOLD" "$1" "$RESET"; }
ok()   { printf '    %s%s%s\n' "$GREEN" "$1" "$RESET"; }
note() { printf '    %s%s%s\n' "$YELLOW" "$1" "$RESET"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Prerequisites
step 'Checking prerequisites'
if ! command -v npm >/dev/null 2>&1; then
    echo "npm was not found. Install Node.js LTS from https://nodejs.org and re-run this script." >&2
    exit 1
fi
ok "node $(node --version), npm $(npm --version)"

# 2. Install / update opencode
if [ "$SKIP_INSTALL" -eq 1 ]; then
    step 'Skipping install (--skip-install)'
else
    step 'Installing latest opencode-ai globally'
    npm install -g opencode-ai@latest
fi

if command -v opencode >/dev/null 2>&1; then
    ok "opencode $(opencode --version 2>/dev/null) installed"
else
    note 'opencode is not on PATH yet. Open a new shell and re-run if needed.'
fi

# 3. Verify workspace config
step 'Verifying workspace config'
config_path="$SCRIPT_DIR/opencode.json"
if [ -f "$config_path" ]; then
    if node -e "JSON.parse(require('fs').readFileSync(process.argv[1], 'utf8'))" "$config_path"; then
        ok 'opencode.json is valid JSON'
    else
        echo "opencode.json is not valid JSON: $config_path" >&2
        exit 1
    fi
else
    note "opencode.json not found at $config_path"
fi

# 4. Ensure local folders
step 'Ensuring local .opencode folders'
for dir in ".opencode/skills" ".opencode/agent"; do
    if [ ! -d "$SCRIPT_DIR/$dir" ]; then
        mkdir -p "$SCRIPT_DIR/$dir"
        ok "created $dir"
    else
        ok "$dir present"
    fi
done

step 'Done'
printf '%sRestart opencode from this directory to load the config, skills, and agents.%s\n' "$CYAN" "$RESET"
