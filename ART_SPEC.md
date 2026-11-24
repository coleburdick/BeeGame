# BeeGame — Art Spec

For the artist. Placeholder art in the repo follows this spec exactly, so final files can replace
placeholders without code changes: **same file name, same frame size, same frame count.**

## Global rules
- Base resolution **640×360**, scaled up by whole numbers. Pixel art, no anti-aliasing to the background.
- **Tile size 16×16.**
- Deliver **PNG** with transparency. Animations as a **horizontal strip**: frames left to right, no
  padding, no gaps. Source `.aseprite` files are welcome alongside but not required.
- Light source: top-left.
- Sprites are drawn facing **right**; the game mirrors them for left.

## Bee
| File | Frame size | Frames | Notes |
|---|---|---|---|
| `assets/art/bee/bee_idle.png` | 24×24 | 2–4 | hovering in place (the game adds a gentle bob) |
| `assets/art/bee/bee_fly.png` | 24×24 | 2–4 | moving |
| `assets/art/bee/bee_collect.png` | 24×24 | 3–6 | plays once when collecting pollen |

The bee's body should sit roughly centred in the frame. Leave the area around the bee's back clear:
the game draws a small coloured **pollen dot** there (about 3×3 px).

## Flowers (36)
IDs: `wild_01` … `wild_08` and hybrids `hybrid_AA_BB` (lower number first, e.g. `hybrid_03_07`).
The designer supplies the recipe table with names and colours.

| File | Frame size | Frames | Notes |
|---|---|---|---|
| `assets/art/flowers/<id>.png` | 16×16 | 1 | used in the world, in the garden, and (scaled) in the journal |
| `assets/art/flowers/<id>_play.png` | 16×16 | 4–6 | plays when the song's playhead reaches this flower; must start and end on the resting pose |

Flowers should read clearly at 16×16 and be distinguishable by **shape as well as colour**.

## Environment
One tileset per area, 16×16 tiles, as a PNG sheet:
- `assets/art/tiles/hub.png`: starting area, including the **garden bed** (6×4 tiles, with distinct
  empty-soil tiles and a highlight/playhead overlay tile)
- `assets/art/tiles/area_1.png` … `area_4.png`: the four flower areas
- Each sheet should include ground, edge transitions to neighbouring areas, decorations, and an outer
  barrier (hedge, water, etc.)

## UI
- `assets/art/ui/pollen_slot.png`: 16×16 empty HUD slot (the game tints the pollen inside)
- `assets/art/ui/pollen.png`: 10×10 pollen ball, drawn white/grey so it can be tinted
- Journal page background, buttons, panel frames: sizes to be agreed in milestone 5–6

## Delivery
Commit to the repo, or send files and they will be dropped into the paths above.
