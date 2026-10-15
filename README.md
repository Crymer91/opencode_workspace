# opencode_workspace
Setup opencode workspace

## Setup

Run the setup script to install the latest opencode on this machine and verify
the workspace config.

Windows (PowerShell):

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

macOS / Linux:

```bash
chmod +x setup.sh
./setup.sh
```

Both scripts accept a skip-install option (`-SkipInstall` / `--skip-install`)
to only verify the config and folders without touching the global install.

## Layout

- `setup.ps1` / `setup.sh` — machine setup scripts (Windows / macOS / Linux)
- `opencode.json` — opencode config (all tool permissions allowed)
- `.opencode/skills/` — local skills
- `.opencode/agent/` — local agents
