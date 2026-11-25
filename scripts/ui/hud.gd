extends CanvasLayer
## Two pollen slots in the top-right corner, tinted by pollen type (see DESIGN.md > HUD).

const SLOT_TEX := preload("res://assets/art/ui/pollen_slot.png")
const POLLEN_TEX := preload("res://assets/art/ui/pollen.png")
const MARGIN := 4
const FULL_FLASH := Color(1.0, 0.45, 0.45)

var _pollen_rects: Array[TextureRect] = []
var _box: HBoxContainer
var _shake: Tween
var _complete_label: Label


func _ready() -> void:
	_complete_label = Label.new()
	_complete_label.text = "Garden Complete!"
	_complete_label.add_theme_font_size_override("font_size", 16)
	_complete_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP, Control.PRESET_MODE_MINSIZE, 24)
	_complete_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_complete_label.visible = false
	add_child(_complete_label)
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


## Small shake when the bee tries to plant without 2 pollens.
func shake_slots() -> void:
	if _shake and _shake.is_running():
		return
	var base := _box.position.x
	_shake = create_tween()
	for dx in [-2.0, 2.0, -1.0, 0.0]:
		_shake.tween_property(_box, "position:x", base + dx, 0.05)


## Placeholder until the Garden Complete moment (milestone 7).
func show_complete(complete: bool) -> void:
	_complete_label.visible = complete
