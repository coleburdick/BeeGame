# BeeGame — Design Document

_Decisions agreed 2026-11-23. This is the source of truth for gameplay; change it when a decision changes._

## Concept
A cozy, top-down pixel-art game. You are a single bee. There are **no threats and no fail state**.
The goal is to fill a 6×4 garden bed with flowers. The finished bed is a **musical composition**:
every flower has its own sound, and the bed plays as a song.

## Core loop
1. Fly to a wild flower and press **Interact** → collect its pollen instantly. One pollen per flower;
   the flower disappears and respawns at a new random spot in its area.
2. The bee carries **exactly 2 pollens**. Pollen can be **dropped** (Drop key) if you change your mind.
3. Fly over an **empty** garden tile with 2 pollens and press **Interact** → plant 1 flower there.
   - Same type: `red + red = red`. Each pollen must come from a different flower.
   - Different types crossbreed: `red + yellow = orange`. Order does not matter.
4. **Hold Interact ~1 s** on a planted tile to remove that flower. Nothing is refunded.
5. Filling all 24 tiles = **"Garden Complete"**. Any combination of flowers counts.

Only **wild** flowers give pollen. Planted garden flowers never do, so every hybrid is wild × wild.

## Flowers
- **8 wild types**, all pairs defined → 8 pure + 28 hybrids = **36 flowers**.
- IDs: `wild_01` … `wild_08`; hybrids `hybrid_AA_BB` with the lower number first (e.g. `hybrid_01_02`).
- The recipe table (which pair makes which flower, names, colours) is owned by the designer and lives in
  `data/flowers` (to be created in milestone 3).

## World
- One seamless map of **6×6 screens** (3840×2160 px at the 640×360 base resolution).
- Size target: a straight diagonal flight from the hub centre to any map corner takes **~15 s** at the
  bee's max speed (140 px/s → ~15.7 s). Resize the map if the speed changes much.
- **Central hub** (the starting area, one screen: 640×360) holds the garden and has **no wild flowers**.
- **4 flower areas** around the hub, each with **2 wild types**. All open from the start.
- Each area (a 1920×1080 quadrant) keeps **4 wild flowers alive** at a time (revisit in the milestone 2
  playtest; areas are large). When one is collected it disappears and a
  replacement spawns at a random valid spot in the same area after ~5–10 s, preferably off-screen,
  never overlapping obstacles or other flowers.
- Area borders blend softly. The outer edge is closed by natural barriers (hedges, water).

## Garden and sequencer
- 6×4 bed, tiles numbered 1–24 in **snake order** (row 1 left→right, row 2 right→left, …).
- Each tile is one **fixed-length slot**. A planted tile plays its flower's sound; an empty tile is a
  silent slot. Sounds follow each other with **no gap** (sample-accurate scheduling).
- When the playhead reaches a flower, that flower plays its **play animation** (plus a code bounce/glow).
- **While building**, the garden loops continuously as the hub's soundtrack, louder near the garden.
  It **pauses when you leave the hub and restarts from tile 1 when you return**.

## Music
- The hub's music is the garden loop. Each of the 4 areas has its own looping track.
- Crossing a border **crossfades** (~2 s) between tracks.

## Garden Complete
When the 24th tile is planted: camera eases over the garden, other music fades, the full song plays
once with every flower animating, then a panel offers **Download song**, **Keep editing**, **New garden**.
Download and replay stay available from the pause menu once the bed is full.

**Download** = a WAV of the full song (rendered offline, identical to in-game playback) plus a PNG of the
garden, saved to a folder the player picks. Intended for sharing in the game's Discord.

## Journal
- Global (shared across all saves). Lists all 36 flowers; undiscovered entries show `???`.
- A recipe is **discovered the first time that pair is planted**. The entry then shows the recipe
  and can play the flower's sound.
- The HUD never previews what a pair will make.

## HUD
- 2 pollen slots coloured by type, plus a small coloured dot on the bee.

## Saves
- **Unlimited, named** garden saves. Each stores the garden grid, carried pollen, and bee position.
  Wild flower positions are re-rolled on load.
- The journal is saved separately (global).
- Autosave on every plant/remove and on quit. Title screen offers Continue / New garden / Load.

## Controls
| Action | Keyboard | Gamepad |
|---|---|---|
| Move | WASD, arrow keys | Left stick, D-pad |
| Interact (collect / plant / hold to remove) | E, Space | A (bottom face) |
| Drop pollen | Q | X (left face) |
| Pause | Esc | Start |

Movement has **light inertia** (short acceleration, slight drift, idle bob). A mobile on-screen
joystick is added when mobile work starts.

## Tech
- Godot 4.7.2, GDScript, **Compatibility** renderer (needed for mobile and web).
- 640×360 base resolution, integer scaling, stretch aspect **expand** (wider screens see more world).
- 16×16 tiles, 24×24 bee frames. See `ART_SPEC.md` and `AUDIO_SPEC.md`.

## Release
- PC first, published **free on itch.io** for playtesting; Steam and mobile decided later.

## Out of scope for the first release
Threats, hive management, upgrades, garden flowers giving pollen, gated areas, share codes,
OGG/MP3 export, mobile build.

## Milestones
Each milestone is a feature branch + PR, playable with placeholder art, playtested before merge.
1. **Flight**: bee movement (WASD/arrows/gamepad), inertia, follow camera, map blockout
2. **Pollen**: wild spawns in 4 areas with respawn, collect, HUD slots, drop
3. **Garden**: 6×4 plot, plant, hold-to-remove, 36-flower recipe table
4. **Sequencer**: sample-accurate snake playback, playhead animation, live loop with distance volume
5. **Area music** with crossfades; **journal**
6. **Saves** (global journal + named gardens), title, pause, settings
7. **Garden Complete** moment and WAV + PNG export
8. **Polish** and itch.io build; swap in final art and audio as it arrives

## Open items (designer)
Recipe table, slot length, area names, flower names, game title.
