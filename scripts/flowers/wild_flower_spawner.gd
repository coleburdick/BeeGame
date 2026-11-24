class_name WildFlowerSpawner
extends Node2D
## Keeps a fixed number of wild flowers alive in each flower area (see DESIGN.md > World).
## A collected flower is replaced by one of the same type, in the same area, after a short delay.

## Flowers alive per area at a time. Revisit after the milestone 2 playtest.
@export var flowers_per_area := 4
@export var respawn_delay_min := 5.0
@export var respawn_delay_max := 10.0
## Minimum distance between two flowers.
@export var min_spacing := 40.0
## Keep-out margin around the hub and inside the outer barrier.
@export var edge_margin := 32.0
## How close the bee must be to a flower to collect it.
@export var collect_radius := 14.0

const SPAWN_ATTEMPTS := 60

var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	for area in FlowerTypes.AREA_TYPES:
		var types: Array = FlowerTypes.AREA_TYPES[area]
		for i in flowers_per_area:
			_spawn(types[i % types.size()], area, false)


func flowers() -> Array[WildFlower]:
	var out: Array[WildFlower] = []
	for child in get_children():
		if child is WildFlower and not child.is_queued_for_deletion():
			out.append(child)
	return out


## The closest flower within collect range of `point`, or null.
func flower_near(point: Vector2) -> WildFlower:
	var best: WildFlower = null
	var best_dist := collect_radius
	for flower in flowers():
		var d := flower.position.distance_to(point)
		if d <= best_dist:
			best = flower
			best_dist = d
	return best


## Removes the flower and schedules a replacement of the same type in the same area.
func collect(flower: WildFlower) -> void:
	var id := flower.type_id
	var area := flower.area
	flower.queue_free()
	var delay := _rng.randf_range(respawn_delay_min, respawn_delay_max)
	get_tree().create_timer(delay, false).timeout.connect(_spawn.bind(id, area, true))


func _spawn(id: StringName, area: MapLayout.Area, prefer_offscreen: bool) -> void:
	var pos: Variant = _find_spot(area, prefer_offscreen)
	if pos == null:
		push_warning("No free spot for %s in area %d" % [id, area])
		return
	var flower := WildFlower.new()
	flower.setup(id, area)
	flower.position = pos
	add_child(flower)


## A random valid tile centre in the area. Tries off-screen spots first when asked,
## then falls back to any valid spot. Returns null if none is found.
func _find_spot(area: MapLayout.Area, prefer_offscreen: bool) -> Variant:
	var bounds: Rect2 = MapLayout.AREA_RECTS[area].intersection(
		MapLayout.WORLD.grow(-(MapLayout.BARRIER_THICKNESS + edge_margin)))
	var view := _view_rect().grow(MapLayout.TILE * 2)
	var passes := [true, false] if prefer_offscreen else [false]
	for offscreen_only in passes:
		for i in SPAWN_ATTEMPTS:
			var p := Vector2(
				_rng.randf_range(bounds.position.x, bounds.end.x),
				_rng.randf_range(bounds.position.y, bounds.end.y))
			p = (p / MapLayout.TILE).floor() * MapLayout.TILE + Vector2.ONE * MapLayout.TILE / 2
			if _is_valid(p, area) and not (offscreen_only and view.has_point(p)):
				return p
	return null


func _is_valid(p: Vector2, area: MapLayout.Area) -> bool:
	if not MapLayout.AREA_RECTS[area].has_point(p):
		return false
	if MapLayout.HUB.grow(edge_margin).has_point(p):
		return false
	for flower in flowers():
		if flower.position.distance_to(p) < min_spacing:
			return false
	return true


func _view_rect() -> Rect2:
	var vp := get_viewport()
	return vp.get_canvas_transform().affine_inverse() * vp.get_visible_rect()
