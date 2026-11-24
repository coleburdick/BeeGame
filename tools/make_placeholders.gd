extends SceneTree
## Generates placeholder art that matches ART_SPEC.md.
## Run: godot --headless --path . -s res://tools/make_placeholders.gd
## Final art from the artist replaces these files by name.

const PALETTE := {
	".": Color(0, 0, 0, 0),
	"K": Color("2b1d14"), # outline
	"Y": Color("f4c542"), # body yellow
	"y": Color("c98f2a"), # body yellow, shaded
	"B": Color("3a2a1a"), # stripe
	"H": Color("5a3d24"), # head
	"W": Color("e8f6ff"), # wing / eye highlight
	"w": Color("a9d3ea"), # wing edge
}

const BODY := [
	".......KKKKKKKK...K.....",
	".....KKBBYYBBYYK.KKK....",
	"....KYYBBYYBBYYYKHHHK...",
	"....KYYBBYYBBYYYHHHWK...",
	"....KYYBBYYBBYYYHHHHK...",
	"..KKKYYBBYYBBYYYHHHHK...",
	"....KyyBByyBByyyKHHHK...",
	".....KKBByyBByyK.KKK....",
	".......KKKKKKKK.........",
]

const WINGS_UP := [
	"........................",
	"........................",
	"........................",
	".......www..www.........",
	"......wWWWwwWWWw........",
	"......wWWWwwWWWw........",
	".......wWWwwWWw.........",
	"........wWw.wWw.....K...",
	".........ww..ww....K....",
]

const WINGS_DOWN := [
	"........................",
	"........................",
	"........................",
	"........................",
	"........................",
	"........................",
	"...wwww....wwww.........",
	"..wWWWWw..wWWWWw....K...",
	"...wwwwwww.wwwww...K....",
]

const TAIL := [
	"........................",
	"........................",
	"........................",
	"........................",
	"........................",
	"........................",
]


func _init() -> void:
	var up := _frame(WINGS_UP)
	var down := _frame(WINGS_DOWN)
	_save_strip([up, down], "res://assets/art/bee/bee_idle.png")
	_save_strip([up, down], "res://assets/art/bee/bee_fly.png")
	print("Placeholders written.")
	quit()


func _frame(wings: Array) -> Array:
	return wings + BODY + TAIL


func _save_strip(frames: Array, path: String) -> void:
	var h: int = frames[0].size()
	var w: int = frames[0][0].length()
	var img := Image.create(w * frames.size(), h, false, Image.FORMAT_RGBA8)
	for f in frames.size():
		var rows: Array = frames[f]
		assert(rows.size() == h, "frame %d has %d rows" % [f, rows.size()])
		for y in h:
			var row: String = rows[y]
			assert(row.length() == w, "frame %d row %d is %d wide" % [f, y, row.length()])
			for x in w:
				img.set_pixel(f * w + x, y, PALETTE[row[x]])
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path.get_base_dir()))
	img.save_png(path)
