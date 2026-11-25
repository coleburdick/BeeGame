extends Node2D

## How long Interact must be held on a planted tile to remove its flower.
@export var remove_hold_time := 1.0

@onready var bee: Bee = $Bee
@onready var garden: Garden = $Garden
@onready var flowers: WildFlowerSpawner = $WildFlowers
@onready var hud: CanvasLayer = $Hud
@onready var area_label: Label = $DebugLayer/AreaLabel

var _target: WildFlower
## The planted tile Interact is being held on, or Garden.NO_CELL.
var _remove_cell := Garden.NO_CELL
var _remove_time := 0.0


func _ready() -> void:
	bee.teleport(MapLayout.BEE_START)
	bee.pollen_changed.connect(hud.show_pollen)
	garden.completed.connect(hud.show_complete.bind(true))
	garden.removed.connect(func(_cell, _id): hud.show_complete(false))
	print("BeeGame started")


func _process(delta: float) -> void:
	area_label.text = MapLayout.AREA_NAMES[MapLayout.area_at(bee.position)]
	_update_target()
	garden.highlighted_cell = garden.cell_at(bee.position)
	_update_remove(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		_interact()
	elif event.is_action_pressed(&"drop_pollen"):
		bee.drop_pollen()


## Highlights the flower the bee would collect from.
func _update_target() -> void:
	var target := flowers.flower_near(bee.position)
	if target == _target:
		return
	if is_instance_valid(_target):
		_target.highlighted = false
	_target = target
	if _target:
		_target.highlighted = true


func _interact() -> void:
	var cell := garden.cell_at(bee.position)
	if garden.is_cell(cell):
		if garden.is_empty(cell):
			_plant(cell)
		else:
			_remove_cell = cell
			_remove_time = 0.0
		return
	if not is_instance_valid(_target):
		return
	if bee.add_pollen(_target.type_id):
		flowers.collect(_target)
		_target = null
	else:
		hud.flash_full()


func _plant(cell: Vector2i) -> void:
	if not bee.is_full():
		hud.shake_slots()
		return
	var pollen := bee.take_pollen()
	garden.plant(cell, FlowerTypes.recipe(pollen[0], pollen[1]))


## Hold Interact on a planted tile to remove it. Releasing or flying off the tile cancels.
func _update_remove(delta: float) -> void:
	if not garden.is_cell(_remove_cell):
		return
	if not Input.is_action_pressed(&"interact") or garden.cell_at(bee.position) != _remove_cell:
		_cancel_remove()
		return
	_remove_time += delta
	garden.set_remove_progress(_remove_cell, _remove_time / remove_hold_time)
	if _remove_time >= remove_hold_time:
		garden.remove(_remove_cell)
		_cancel_remove()


func _cancel_remove() -> void:
	_remove_cell = Garden.NO_CELL
	_remove_time = 0.0
	garden.set_remove_progress(Garden.NO_CELL, 0.0)
