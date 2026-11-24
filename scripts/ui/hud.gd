extends CanvasLayer
## Two pollen slots in the top-right corner, tinted by pollen type (see DESIGN.md > HUD).

const SLOT_TEX := preload("res://assets/art/ui/pollen_slot.png")
const POLLEN_TEX := preload("res://assets/art/ui/pollen.png")
const MARGIN := 4
const FULL_FLASH := Color(1.0, 0.45, 0.45)

var _pollen_rects: Array[TextureRect] = []
var _box: HBoxContainer


func _ready() -> void:
	_box = HBoxContainer.new()
	_box.add_theme_constant_override("separation", 2)
	_box.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_MINSIZE, MARGIN)
	_box.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	add_child(_box)
	for i in Bee.MAX_POLLEN:
		var slot := TextureRect.new()
		slot.texture = SLOT_TEX
		slot.stretch_mode = TextureRect.STRETCH_KEEP
		_box.add_child(slot)
		var pollen := TextureRect.new()
		pollen.texture = POLLEN_TEX
		pollen.stretch_mode = TextureRect.STRETCH_KEEP
		pollen.position = (SLOT_TEX.get_size() - POLLEN_TEX.get_size()) / 2
		pollen.visible = false
		slot.add_child(pollen)
		_pollen_rects.append(pollen)


func show_pollen(pollen: Array[StringName]) -> void:
	for i in _pollen_rects.size():
		var rect := _pollen_rects[i]
		rect.visible = i < pollen.size()
		if rect.visible:
			rect.modulate = FlowerTypes.color(pollen[i])


## Brief red flash when the bee tries to collect with both slots full.
func flash_full() -> void:
	_box.modulate = FULL_FLASH
	create_tween().tween_property(_box, "modulate", Color.WHITE, 0.35)
