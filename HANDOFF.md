# Handoff Note — BeeGame

_Last updated: 2026-11-23_

## Current state
- Project folder holds only `.gitignore` and this note (no Godot project yet).
- **Git** 2.56.1 installed via winget. Branch `main` tracks `origin/main`.
- **Remote:** private repo https://github.com/coleburdick/BeeGame (HTTPS, Git Credential Manager).
- Global git identity: `coleburdick` / `360410203+coleburdick@users.noreply.github.com` (GitHub noreply).
- `.gitignore` covers Godot 4 (`.godot/`, `.import/`, export presets), Mono/C#, build output, Aseprite backups, OS/editor files, and `.claude/settings.local.json`.
- **GitHub MCP server** (`github` → `https://api.githubcopilot.com/mcp/`) is loaded and authenticated as `coleburdick`.
- Other MCP servers connected: `godot`, `aseprite`, `claude.ai Claude Docs`.

## Next
- Create the Godot project.

## Notes
- The fine-grained PAT can't create repositories (403). Create new repos on github.com, or regenerate the PAT with Administration: Read and write.
- The PAT was shown in a chat transcript when the MCP server was added. Consider regenerating it.
- `gh` CLI is not installed. Use the GitHub MCP for repo operations.
