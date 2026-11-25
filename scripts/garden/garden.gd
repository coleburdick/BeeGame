class_name Garden
extends Node2D
## The 6×4 garden bed in the hub (see DESIGN.md > Core loop, Garden and sequencer).
## Holds one flower per tile, draws the planted flowers, the tile under the bee, and remove progress.
## Cells are Vector2i(column, row); tiles are numbered 1–24 in snake order for the sequencer.

signal planted(cell: Vector2i, id: StringName)
signal removed(cell: Vector2i, id: StringName)
## All 24 tiles are planted.
signal completed

const EMPTY := &""
const NO_CELL := Vector2i(-1, -1)
const COLS := MapLayout.GARDEN_COLS
const ROWS := MapLayout.GARDEN_ROWS
const HIGHLIGHT := Color(1, 1, 1, 0.75)
const PROGRESS_BACK := Color("2b1d14")
const PROGRESS_FILL := Color("f3e2b3")

## Flower per cell, indexed row * COLS + column. EMPTY when nothing is planted.
var _tiles: Array[StringName] = []
var _sprites: Array[Sprite2D] = []
## Drawn above the flower sprites.
var _overlay: Node2D

## The tile the bee is over, outlined. NO_CELL hides the outline.
var highlighted_cell := NO_CELL:
	set(value):
		if highlighted_cell != value:
			highlighted_cell = value
			_overlay.queue_redraw()

var _remove_cell := NO_CELL
var _remove_progress := 0.0


func _ready() -> void:
	_tiles.resize(COLS * ROWS)
	_tiles.fill(EMPTY)
	for i in _tiles.size():
		var sprite := Sprite2D.new()
		sprite.position = cell_center(Vector2i(i % COLS, i / COLS))
		sprite.visible = false
		add_child(sprite)
		_sprites.append(sprite)
	_overlay = Node2D.new()
	_overlay.name = "Overlay"
	_overlay.draw.connect(_draw_overlay)
	add_child(_overlay)


## The cell under a world point, or NO_CELL outside the bed.
func cell_at(point: Vector2) -> Vector2i:
	if not MapLayout.GARDEN.has_point(point):
		return NO_CELL
	var local := ((point - MapLayout.GARDEN.position) / MapLayout.TILE).floor()
	return Vector2i(clampi(int(local.x), 0, COLS - 1), clampi(int(local.y), 0, ROWS - 1))


func cell_center(cell: Vector2i) -> Vector2:
	return MapLayout.GARDEN.position + (Vector2(cell) + Vector2(0.5, 0.5)) * MapLayout.TILE


func is_cell(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < COLS and cell.y >= 0 and cell.y < ROWS


func flower_at(cell: Vector2i) -> StringName:
	return _tiles[_index(cell)] if is_cell(cell) else EMPTY


func is_empty(cell: Vector2i) -> bool:
	return flower_at(cell) == EMPTY


func planted_count() -> int:
	return _tiles.size() - _tiles.count(EMPTY)


func is_full() -> bool:
	return not EMPTY in _tiles


## Plants a flower on an empty tile. Returns false if the tile is taken or not in the bed.
func plant(cell: Vector2i, id: StringName) -> bool:
	if not is_cell(cell) or not is_empty(cell):
		return false
	_tiles[_index(cell)] = id
	var sprite := _sprites[_index(cell)]
	sprite.texture = FlowerTypes.texture(id)
	sprite.modulate = Color.WHITE
	sprite.visible = true
	sprite.scale = Vector2(0.4, 0.4)
	create_tween().tween_property(sprite, "scale", Vector2.ONE, 0.25) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	planted.emit(cell, id)
	if is_full():
		completed.emit()
	return true


## Removes the flower on a tile. Nothing is refunded. Returns false if the tile is empty.
func remove(cell: Vector2i) -> bool:
	if is_empty(cell):
		return false
	var id := flower_at(cell)
	_tiles[_index(cell)] = EMPTY
	_sprites[_index(cell)].visible = false
	if cell == _remove_cell:
		set_remove_progress(NO_CELL, 0.0)
	removed.emit(cell, id)
	return true


## Shows how far a hold-to-remove has got (0–1) on one tile. NO_CELL clears it.
func set_remove_progress(cell: Vector2i, progress: float) -> void:
	if is_cell(_remove_cell) and _remove_cell != cell:
		_sprites[_index(_remove_cell)].modulate = Color.WHITE
	_remove_cell = cell
	_remove_progress = clampf(progress, 0.0, 1.0)
	if is_cell(cell):
		_sprites[_index(cell)].modulate = Color(1, 1, 1, 1.0 - 0.6 * _remove_progress)
	_overlay.queue_redraw()


## Tile number 1–24 in snake order: row 1 left→right, row 2 right→left, …
static func snake_number(cell: Vector2i) -> int:
	var col := cell.x if cell.y % 2 == 0 else COLS - 1 - cell.x
	return cell.y * COLS + col + 1


static func cell_for_snake_number(n: int) -> Vector2i:
	var row := (n - 1) / COLS
	var col := (n - 1) % COLS
	return Vector2i(col if row % 2 == 0 else COLS - 1 - col, row)


## Flowers in snake order (EMPTY for silent tiles), for the sequencer.
func snake_sequence() -> Array[StringName]:
	var out: Array[StringName] = []
	for n in range(1, COLS * ROWS + 1):
		out.append(flower_at(cell_for_snake_number(n)))
	return out


func _index(cell: Vector2i) -> int:
	return cell.y * COLS + cell.x


func _draw_overlay() -> void:
	if is_cell(highlighted_cell):
		var rect := Rect2(cell_center(highlighted_cell) - Vector2.ONE * MapLayout.TILE / 2,
			Vector2.ONE * MapLayout.TILE)
		_overlay.draw_rect(rect.grow(-0.5), HIGHLIGHT, false, 1.0)
	if is_cell(_remove_cell) and _remove_progress > 0.0:
		var c := cell_center(_remove_cell)
		var bar := Rect2(c.x - 7, c.y + 5, 14, 3)
		_overlay.draw_rect(bar, PROGRESS_BACK)
		_overlay.draw_rect(Rect2(bar.position + Vector2.ONE,
			Vector2(roundf(12 * _remove_progress), 1)), PROGRESS_FILL)
