extends Node2D
## Blockout of the map: coloured areas, hub, garden bed, decoration specks, and edge barriers.
## Replaced by real tilemaps once the artist's tilesets arrive.

const AREA_COLORS := {
	MapLayout.Area.AREA_1: Color("9bc95a"),
	MapLayout.Area.AREA_2: Color("5f8f4a"),
	MapLayout.Area.AREA_3: Color("6fa8a0"),
	MapLayout.Area.AREA_4: Color("a89f7a"),
}
const HUB_COLOR := Color("86c06c")
const BARRIER_COLOR := Color("2f5a2a")
const SOIL_COLOR := Color("6b4a2f")
const SOIL_LINE := Color("4e3520")
const SPECK_COUNT := 3600


func _ready() -> void:
	_build_barriers()


func _draw() -> void:
	for area in MapLayout.AREA_RECTS:
		draw_rect(MapLayout.AREA_RECTS[area], AREA_COLORS[area])
	draw_rect(MapLayout.HUB, HUB_COLOR)
	_draw_specks()
	_draw_garden()
	_draw_barriers()
	_draw_labels()


## Deterministic specks so motion is readable on flat colour.
func _draw_specks() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 1234
	for i in SPECK_COUNT:
		var p := Vector2(
			floorf(rng.randf_range(0, MapLayout.WORLD.size.x)),
			floorf(rng.randf_range(0, MapLayout.WORLD.size.y)))
		var base: Color = HUB_COLOR
		var area := MapLayout.area_at(p)
		if area != MapLayout.Area.HUB:
			base = AREA_COLORS[area]
		draw_rect(Rect2(p, Vector2(2, 1)), base.darkened(0.15))


func _draw_garden() -> void:
	var g := MapLayout.GARDEN
	draw_rect(g.grow(2), SOIL_LINE)
	draw_rect(g, SOIL_COLOR)
	for c in range(1, MapLayout.GARDEN_COLS):
		var x := g.position.x + c * MapLayout.TILE
		draw_line(Vector2(x, g.position.y), Vector2(x, g.end.y), SOIL_LINE)
	for r in range(1, MapLayout.GARDEN_ROWS):
		var y := g.position.y + r * MapLayout.TILE
		draw_line(Vector2(g.position.x, y), Vector2(g.end.x, y), SOIL_LINE)


func _draw_barriers() -> void:
	for rect in _barrier_rects():
		draw_rect(rect.intersection(MapLayout.WORLD), BARRIER_COLOR)


func _draw_labels() -> void:
	var font := ThemeDB.fallback_font
	for area in MapLayout.AREA_RECTS:
		var center: Vector2 = MapLayout.AREA_RECTS[area].get_center()
		draw_string(font, center, MapLayout.AREA_NAMES[area], HORIZONTAL_ALIGNMENT_CENTER, -1, 16,
			Color(0, 0, 0, 0.35))


## Barriers sit on the world edge, extending outward so fast movement can't tunnel through.
func _barrier_rects() -> Array[Rect2]:
	var w := MapLayout.WORLD
	var t := MapLayout.BARRIER_THICKNESS
	var out := 64.0
	return [
		Rect2(w.position.x - out, w.position.y - out, w.size.x + out * 2, out + t),
		Rect2(w.position.x - out, w.end.y - t, w.size.x + out * 2, out + t),
		Rect2(w.position.x - out, w.position.y - out, out + t, w.size.y + out * 2),
		Rect2(w.end.x - t, w.position.y - out, out + t, w.size.y + out * 2),
	]


func _build_barriers() -> void:
	var body := StaticBody2D.new()
	body.name = "Barriers"
	add_child(body)
	for rect in _barrier_rects():
		var shape := RectangleShape2D.new()
		shape.size = rect.size
		var col := CollisionShape2D.new()
		col.shape = shape
		col.position = rect.get_center()
		body.add_child(col)
