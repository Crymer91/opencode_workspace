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

## Model / provider

The default model is `deepseek/deepseek-flash`, configured in `opencode.json`.
The API key is read from the `DEEPSEEK_API_KEY` environment variable:

```powershell
# Windows (current session)
$env:DEEPSEEK_API_KEY = "<your-key>"
```

```bash
# macOS / Linux
export DEEPSEEK_API_KEY="<your-key>"
```

Alternatively, store it once with `opencode auth login deepseek`; the
`{env:DEEPSEEK_API_KEY}` value in `opencode.json` takes precedence when the
variable is set.

## Layout

- `setup.ps1` / `setup.sh` — machine setup scripts (Windows / macOS / Linux)
- `opencode.json` — opencode config (all tool permissions allowed)
- `.opencode/skills/` — local skills
- `.opencode/agent/` — local agents
