# Handoff Note — BeeGame

_Last updated: 2026-11-23_

## Current state
- Design is settled: `DESIGN.md` (gameplay + milestones), `ART_SPEC.md` and `AUDIO_SPEC.md` (for the artist/composer).
- Settings: 640x360 viewport, 1280x720 window, stretch aspect `expand`, integer scaling, nearest filter, 2D pixel snap, **Compatibility renderer** (mobile/web ready).
- **Milestone 1 (Flight)** on branch `milestone-1-flight` (PR open): bee with inertia + idle bob, WASD/arrows/gamepad, follow camera clamped to the 1920x1080 map, blockout of hub + garden bed + 4 area quadrants, edge barriers. Input map also defines `interact`, `drop_pollen`, `pause` for later milestones.
- Map geometry lives in `scripts/world/map_layout.gd` (`MapLayout`). Sprite strips load via `SpriteStrips.build()`, which derives frame count from image width.
- Placeholder art: `godot --headless --path . -s res://tools/make_placeholders.gd`, then `godot --headless --path . --import`.
- Verification trick: `--write-movie <dir>/f.png --fixed-fps 30 --quit-after N` dumps frames to view; a temporary `-s` SceneTree script can instantiate `main.tscn` and drive `Input.action_press`.
- Python is not installed; use bash/sed or GDScript tools for scripting.
- **Use the 64-bit Godot:** `C:\Users\colem\Godot\4.7.2\Godot_v4.7.2-stable_win64.exe`. The 32-bit build in `Downloads\4.7.2` crashes the editor on startup (signal 4, illegal instruction) with any project. The Godot MCP's `GODOT_PATH` in `~/.claude.json` now points to the 64-bit build.
- **Git** 2.56.1 installed via winget. Branch `main` tracks `origin/main`.
- **Remote:** private repo https://github.com/coleburdick/BeeGame (HTTPS, Git Credential Manager).
- Global git identity: `coleburdick` / `360410203+coleburdick@users.noreply.github.com` (GitHub noreply).
- `.gitignore` covers Godot 4 (`.godot/`, `.import/`, export presets), Mono/C#, build output, Aseprite backups, OS/editor files, and `.claude/settings.local.json`.
- **GitHub MCP server** (`github` → `https://api.githubcopilot.com/mcp/`) is loaded and authenticated as `coleburdick`.
- Other MCP servers connected: `godot`, `aseprite`, `claude.ai Claude Docs`.

## Next
- Playtest milestone 1 PR; tune `Bee` exports (max_speed, acceleration, friction).
- Milestone 2 (Pollen): wild flower spawns (4 per area, 2 types per area), collect via `interact`, HUD slots, drop.
- Designer to supply: recipe table, slot length, area/flower names, game title.

## Notes
- The fine-grained PAT can't create repositories (403). Create new repos on github.com, or regenerate the PAT with Administration: Read and write.
- The PAT was shown in a chat transcript when the MCP server was added. Consider regenerating it.
- `gh` CLI is not installed. Use the GitHub MCP for repo operations.
