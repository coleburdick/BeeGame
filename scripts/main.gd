extends Node2D

@onready var bee: Bee = $Bee
@onready var flowers: WildFlowerSpawner = $WildFlowers
@onready var hud: CanvasLayer = $Hud
@onready var area_label: Label = $DebugLayer/AreaLabel

var _target: WildFlower


func _ready() -> void:
	bee.teleport(MapLayout.BEE_START)
	bee.pollen_changed.connect(hud.show_pollen)
	print("BeeGame started")


func _process(_delta: float) -> void:
	area_label.text = MapLayout.AREA_NAMES[MapLayout.area_at(bee.position)]
	_update_target()


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
	if not is_instance_valid(_target):
		return
	if bee.add_pollen(_target.type_id):
		flowers.collect(_target)
		_target = null
	else:
		hud.flash_full()
