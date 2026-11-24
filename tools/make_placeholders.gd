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
	_save_strip([down, up, down], "res://assets/art/bee/bee_collect.png")
	for i in FlowerTypes.WILD.size():
		var id: StringName = FlowerTypes.WILD[i]
		_save_image(_flower(FlowerTypes.color(id), PETALS[i], PETAL_RADIUS[i]),
			"res://assets/art/flowers/%s.png" % id)
	_save_image(_pollen_slot(), "res://assets/art/ui/pollen_slot.png")
	_save_image(_pollen(), "res://assets/art/ui/pollen.png")
	print("Placeholders written.")
	quit()


# --- Flowers: 16x16, distinct petal count and size per wild type -------------------------

const FlowerTypes := preload("res://scripts/flowers/flower_types.gd")
const PETALS := [4, 5, 3, 6, 8, 4, 5, 6]
const PETAL_RADIUS := [2.6, 2.0, 2.8, 1.8, 1.5, 2.0, 2.6, 2.2]
const STEM := Color("3f7a2c")
const LEAF := Color("5aa23a")
const CENTER := Color("6b4a1f")
const OUTLINE := Color("2b1d14")


func _flower(petal: Color, count: int, radius: float) -> Image:
	var img := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	for y in range(9, 15):
		img.set_pixel(8, y, STEM)
	for p in [Vector2i(9, 11), Vector2i(10, 11), Vector2i(10, 10), Vector2i(6, 12), Vector2i(7, 12)]:
		img.set_pixel(p.x, p.y, LEAF)
	var head := Vector2(8.5, 6.5)
	var shade := petal.darkened(0.25)
	for i in count:
		var a := TAU * i / count - PI / 2
		var c := head + Vector2(cos(a), sin(a)) * 3.2
		for y in 16:
			for x in 16:
				var px := Vector2(x + 0.5, y + 0.5)
				if px.distance_to(c) <= radius:
					# Shade the side away from the top-left light.
					img.set_pixelv(Vector2i(x, y), shade if px.x + px.y > c.x + c.y + 1.0 else petal)
	for y in 16:
		for x in 16:
			if Vector2(x + 0.5, y + 0.5).distance_to(head) <= 1.6:
				img.set_pixel(x, y, CENTER)
	return _outline(img)


## Adds a 1 px dark outline around every opaque pixel.
func _outline(img: Image) -> Image:
	var out := img.duplicate()
	for y in img.get_height():
		for x in img.get_width():
			if img.get_pixel(x, y).a > 0.0:
				continue
			for d in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
				var n: Vector2i = Vector2i(x, y) + d
				if Rect2i(0, 0, img.get_width(), img.get_height()).has_point(n) \
						and img.get_pixelv(n).a > 0.0:
					out.set_pixel(x, y, OUTLINE)
					break
	return out


# --- UI ---------------------------------------------------------------------------------

func _pollen_slot() -> Image:
	var img := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	img.fill_rect(Rect2i(1, 1, 14, 14), Color("2b1d14"))
	img.fill_rect(Rect2i(2, 2, 12, 12), Color("f3e2b3"))
	img.fill_rect(Rect2i(3, 3, 10, 10), Color("e2cc92"))
	return img


## White/grey ball so the game can tint it.
func _pollen() -> Image:
	var img := Image.create(10, 10, false, Image.FORMAT_RGBA8)
	var c := Vector2(5, 5)
	for y in 10:
		for x in 10:
			var px := Vector2(x + 0.5, y + 0.5)
			var d := px.distance_to(c)
			if d <= 4.6:
				var col := Color("ffffff") if px.distance_to(Vector2(3.8, 3.8)) < 2.0 else Color("d8d8d8")
				if px.x + px.y > 12.0:
					col = Color("a8a8a8")
				img.set_pixel(x, y, col)
			elif d <= 5.0:
				img.set_pixel(x, y, Color("6a6a6a"))
	return img


func _save_image(img: Image, path: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path.get_base_dir()))
	img.save_png(path)


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
