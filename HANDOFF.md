# Handoff Note — BeeGame

_Last updated: 2026-11-23_

## Current state
- Project folder holds only `.gitignore` and this note (no Godot project yet).
- **Git** 2.56.1 installed via winget. Repo on branch `main`, initial commit made.
- Global git identity: `coleburdick` / `360410203+coleburdick@users.noreply.github.com` (GitHub noreply).
- `.gitignore` covers Godot 4 (`.godot/`, `.import/`, export presets), Mono/C#, build output, Aseprite backups, OS/editor files, and `.claude/settings.local.json`.
- **GitHub MCP server** (`github` → `https://api.githubcopilot.com/mcp/`) is loaded and authenticated as GitHub user `coleburdick`.
- Other MCP servers connected: `godot`, `aseprite`, `claude.ai Claude Docs`.

## Blocked
- Creating the GitHub repo via MCP failed: `403 Resource not accessible by personal access token`.
  The fine-grained PAT can't create repositories. Either:
  - **Option A:** create a **private** repo named `BeeGame` on github.com yourself (no README/license/.gitignore), or
  - **Option B:** regenerate the PAT with **Repository access: All repositories** and
    **Administration: Read and write** + **Contents: Read and write**, then re-add the MCP server and restart.
- After that: `git remote add origin https://github.com/coleburdick/BeeGame.git` and `git push -u origin main`.
  Pushing over HTTPS uses Git Credential Manager (browser sign-in on first push).

## Notes
- The PAT was shown in a chat transcript when the MCP server was added. Consider regenerating it (Option B handles this too).
- `gh` CLI is not installed. Use the GitHub MCP for repo operations.
