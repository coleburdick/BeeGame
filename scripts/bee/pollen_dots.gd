extends Node2D
## Small coloured dots on the bee's back, one per carried pollen (see ART_SPEC.md > Bee).

const DOT := Vector2(3, 3)
const OUTLINE := Color("2b1d14")
## Top-left of each dot, for a bee facing right. Mirrored when the bee faces left.
const SLOTS := [Vector2(-7, -4), Vector2(-3, -4)]

var colors: Array[Color] = []:
	set(value):
		colors = value
		queue_redraw()

var facing_left := false:
	set(value):
		if facing_left != value:
			facing_left = value
			queue_redraw()


func _draw() -> void:
	for i in mini(colors.size(), SLOTS.size()):
		var p: Vector2 = SLOTS[i]
		if facing_left:
			p.x = -p.x - DOT.x
		draw_rect(Rect2(p - Vector2.ONE, DOT + Vector2(2, 2)), OUTLINE)
		draw_rect(Rect2(p, DOT), colors[i])
