extends Node2D

@onready var bee: Bee = $Bee
@onready var area_label: Label = $DebugLayer/AreaLabel


func _ready() -> void:
	bee.teleport(MapLayout.BEE_START)
	print("BeeGame started")


func _process(_delta: float) -> void:
	area_label.text = MapLayout.AREA_NAMES[MapLayout.area_at(bee.position)]
