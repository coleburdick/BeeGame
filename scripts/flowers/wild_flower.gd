class_name WildFlower
extends Sprite2D
## A wild flower in a flower area. Gives one pollen, then disappears (the spawner replaces it).

const HIGHLIGHT := Color(1.35, 1.35, 1.35)

var type_id: StringName
var area: MapLayout.Area

var highlighted := false:
	set(value):
		highlighted = value
		modulate = HIGHLIGHT if value else Color.WHITE


func setup(id: StringName, in_area: MapLayout.Area) -> void:
	type_id = id
	area = in_area
	texture = FlowerTypes.texture(id)
	name = "%s_%d" % [id, get_instance_id()]
