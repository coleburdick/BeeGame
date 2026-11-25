# Handoff Note — BeeGame

_Last updated: 2026-11-24_

## Current state
- Design is settled: `DESIGN.md` (gameplay + milestones), `ART_SPEC.md` and `AUDIO_SPEC.md` (for the artist/composer).
- Settings: 640x360 viewport, 1280x720 window, stretch aspect `expand`, integer scaling, nearest filter, 2D pixel snap, **Compatibility renderer** (mobile/web ready).
- **Milestone 1 (Flight)** merged into `main` (PR #1): bee with inertia + idle bob (max_speed 140, accel 650, friction 450, tuned after playtest), WASD/arrows/gamepad, follow camera clamped to the 3840x2160 map (6x6 screens, ~15 s centre-to-corner), blockout of hub + garden bed + 4 area quadrants, edge barriers. Input map also defines `interact`, `drop_pollen`, `pause` for later milestones.
- **Milestone 2 (Pollen)** merged into `main` (PR #2, 2026-11-23): `WildFlowerSpawner` (`scripts/flowers/`) keeps 4 flowers per area (export `flowers_per_area`), 2 types per area (`FlowerTypes.AREA_TYPES`), tile-snapped, 40 px apart, out of the hub; a collected flower respawns as the same type in the same area after 5–10 s, off-screen if possible. `interact` collects from the nearest flower within 14 px (highlighted); with both slots full the HUD flashes red. `drop_pollen` drops the most recent pollen. HUD: 2 slots top-right; pollen dots on the bee's back. No playtest feedback was recorded before the merge.
- **Milestone 3 (Garden)** playtested; PR open from `milestone-3-garden` (see Next).
- Map geometry lives in `scripts/world/map_layout.gd` (`MapLayout`). Sprite strips load via `SpriteStrips.build()`, which derives frame count from image width.
- Placeholder art: `godot --headless --path . -s res://tools/make_placeholders.gd`, then `godot --headless --path . --import`. It now also draws the 28 hybrids (petals alternate both parents' colours).
- Verification trick: `--write-movie <dir>/f.png --fixed-fps 30 --quit-after N` dumps frames to view; a temporary `-s` SceneTree script (an absolute path outside the project works) can instantiate `main.tscn` and drive input. Use `Input.parse_input_event(InputEventAction)` so `_unhandled_input` sees presses; `Input.action_press` only sets the held state. Screenshots need a windowed run (no `--headless`): `root.get_texture().get_image()`.
- Resolution checks: `--write-movie` saves at the 640x360 base size, headless ignores `--resolution`, and the monitor caps windows at ~1920 wide. To check aspect ratios, run windowed with `--resolution 1920x810` (21:9) and save `root.get_texture().get_image()` from a `-s` script.
- Python is not installed; use bash/sed/awk or GDScript tools for scripting.
- **Use the 64-bit Godot:** `C:\Users\colem\Godot\4.7.2\Godot_v4.7.2-stable_win64.exe`. The 32-bit build in `Downloads\4.7.2` crashes the editor on startup (signal 4, illegal instruction) with any project. The Godot MCP's `GODOT_PATH` in `~/.claude.json` now points to the 64-bit build.
- **Git** 2.56.1 installed via winget. `core.autocrlf=true`. Godot rewrites `.png.import` files with LF, so they show as modified with no real diff; leave them out of commits (or add a `.gitattributes` later).
- **Remote:** private repo https://github.com/coleburdick/BeeGame (HTTPS, Git Credential Manager).
- Global git identity: `coleburdick` / `360410203+coleburdick@users.noreply.github.com` (GitHub noreply).
- `.gitignore` covers Godot 4 (`.godot/`, `.import/`, export presets), Mono/C#, build output, Aseprite backups, OS/editor files, and `.claude/settings.local.json`.
- **GitHub MCP server** (`github` → `https://api.githubcopilot.com/mcp/`) is loaded and authenticated as `coleburdick`.
- Other MCP servers connected: `godot`, `aseprite`, `claude.ai Claude Docs`.

## Next
- **Milestone 3 (Garden)** on `milestone-3-garden`, playtested and approved 2026-11-24 (tile targeting, 1 s hold, shake, flower count and collect range all fine); PR open:
  - Recipe table `data/flowers/flowers.csv` (`id,name,color`, placeholder values; `.import` set to `keep` so Godot doesn't treat it as translations). `FlowerTypes` loads it, checks all 36 IDs, and gives `recipe(a, b)`, `display_name()`, `color()`.
  - `Garden` (`scripts/garden/garden.gd`, node in `main.tscn`): 6x4 grid, outlines the tile under the bee, `plant`/`remove`, signals `planted`/`removed`/`completed`, snake-order helpers (`snake_number`, `cell_for_snake_number`, `snake_sequence`) ready for the milestone 4 sequencer.
  - `main.gd`: Interact on an empty tile with 2 pollens plants `recipe(p1, p2)` (pop-in tween); with fewer the HUD slots shake. Holding Interact 1 s (export `remove_hold_time`) on a planted tile removes it, with a progress bar and fade; releasing or flying off cancels.
  - Placeholder "Garden Complete!" label when all 24 are planted (the real moment is milestone 7).
  - Automated check passed (28 checks: table, recipes, snake order, plant rules, hold/cancel/remove, fill to complete).
- **Gamepad untested** (no controller available). Test stick + d-pad + buttons when one is available.
- Milestone 4 (Sequencer) next: sample-accurate snake playback, playhead animation, live loop with distance volume. Needs the slot length.
- Designer to supply: recipe table (names, colours), slot length, area names, game title.

## Notes
- The GitHub MCP PAT was updated 2026-11-23 and can now open pull requests.
- The PAT was shown in a chat transcript when the MCP server was added. Consider regenerating it.
- `gh` CLI is not installed. Use the GitHub MCP for repo operations.
