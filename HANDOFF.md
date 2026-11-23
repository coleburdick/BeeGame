# Handoff Note — BeeGame

_Last updated: 2026-11-23_

## Current state
- Godot 4.7.2 project created: `project.godot`, `icon.svg`, `scenes/main.tscn` (main scene: Node2D + Camera2D), `scripts/main.gd`, `assets/sprites/`.
- Settings: 640x360 viewport stretched to a 1280x720 window, nearest-neighbor texture filter (pixel art), Forward+ renderer.
- Verified: runs with no errors and prints "BeeGame started".
- **Use the 64-bit Godot:** `C:\Users\colem\Godot\4.7.2\Godot_v4.7.2-stable_win64.exe`. The 32-bit build in `Downloads\4.7.2` crashes the editor on startup (signal 4, illegal instruction) with any project. The Godot MCP's `GODOT_PATH` in `~/.claude.json` now points to the 64-bit build.
- **Git** 2.56.1 installed via winget. Branch `main` tracks `origin/main`.
- **Remote:** private repo https://github.com/coleburdick/BeeGame (HTTPS, Git Credential Manager).
- Global git identity: `coleburdick` / `360410203+coleburdick@users.noreply.github.com` (GitHub noreply).
- `.gitignore` covers Godot 4 (`.godot/`, `.import/`, export presets), Mono/C#, build output, Aseprite backups, OS/editor files, and `.claude/settings.local.json`.
- **GitHub MCP server** (`github` → `https://api.githubcopilot.com/mcp/`) is loaded and authenticated as `coleburdick`.
- Other MCP servers connected: `godot`, `aseprite`, `claude.ai Claude Docs`.

## Next
- Design the bee player and first gameplay loop.

## Notes
- The fine-grained PAT can't create repositories (403). Create new repos on github.com, or regenerate the PAT with Administration: Read and write.
- The PAT was shown in a chat transcript when the MCP server was added. Consider regenerating it.
- `gh` CLI is not installed. Use the GitHub MCP for repo operations.
