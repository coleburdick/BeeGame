# BeeGame — Audio Spec

For the composer. Placeholder sounds in the repo follow this spec exactly, so final files can replace
them by name.

## Format (all files)
- **WAV, 44.1 kHz, 16-bit.** Stereo or mono, but be consistent within each category.
- No leading silence: the sound starts on the very first sample.

## Flower sounds (36)
`assets/audio/flowers/<id>.wav`, where `<id>` is `wild_01` … `wild_08` or `hybrid_AA_BB` (lower number first).

- Every flower sound is **exactly the same length** (one slot), down to the sample.
  Example: a 2.000 s slot = exactly 88,200 samples.
- The game plays slot after slot with **zero gap**, so anything past the slot end is cut. Bake any
  reverb or decay inside the slot.
- An empty garden tile is a silent slot of the same length.
- The song is 24 slots long in snake order. At 2 s per slot that's 48 s. Keep the full song under
  ~55 s at stereo 16-bit, or ~110 s mono, so the exported WAV stays under Discord's 10 MB limit.
- Tell the developer the slot length once it is chosen; it is a single value in the game.

## Area music
- `assets/audio/music/music_area_1.wav` … `music_area_4.wav`, one per flower area.
- Must **loop seamlessly**: the last sample flows into the first.
- The hub has no track of its own: the garden's song is the hub's music.
- The game crossfades over ~2 s at area borders.

## Sound effects
Short one-shots in `assets/audio/sfx/`:
| File | When |
|---|---|
| `sfx_collect.wav` | pollen collected |
| `sfx_plant.wav` | flower planted (can be omitted if the flower's own sound is enough) |
| `sfx_remove.wav` | flower removed |
| `sfx_drop.wav` | pollen dropped |
| `sfx_ui_move.wav`, `sfx_ui_select.wav`, `sfx_ui_back.wav` | menus |
| `sfx_journal_discover.wav` | new recipe discovered |

Optional: `sfx_bee_wings_loop.wav`, a quiet seamless loop for flying.
