class_name Bee
extends CharacterBody2D
## The player. Top-down flight with light inertia and an idle bob.

@export var max_speed := 110.0
## How fast the bee reaches max speed (px/s²).
@export var acceleration := 650.0
## How fast the bee drifts to a stop when input is released (px/s²).
@export var friction := 450.0
## Speed above which the fly animation plays.
@export var fly_anim_threshold := 15.0
@export var bob_height := 1.5
@export var bob_speed := 3.0

const FRAME_SIZE := Vector2i(24, 24)

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var camera: Camera2D = $Camera2D

var _bob_time := 0.0


func _ready() -> void:
	sprite.sprite_frames = SpriteStrips.build({
		&"idle": {"path": "res://assets/art/bee/bee_idle.png", "fps": 8.0},
		&"fly": {"path": "res://assets/art/bee/bee_fly.png", "fps": 14.0},
	}, FRAME_SIZE)
	sprite.play(&"idle")
	var world := MapLayout.WORLD
	camera.limit_left = int(world.position.x)
	camera.limit_top = int(world.position.y)
	camera.limit_right = int(world.end.x)
	camera.limit_bottom = int(world.end.y)


## Moves the bee instantly, with no camera pan or leftover momentum.
func teleport(to: Vector2) -> void:
	position = to
	velocity = Vector2.ZERO
	camera.reset_smoothing()


func _physics_process(delta: float) -> void:
	var input := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	if input != Vector2.ZERO:
		velocity = velocity.move_toward(input * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()
	_update_visuals(delta, input)


func _update_visuals(delta: float, input: Vector2) -> void:
	if input.x != 0.0:
		sprite.flip_h = input.x < 0.0
	var anim := &"fly" if velocity.length() > fly_anim_threshold else &"idle"
	if sprite.animation != anim:
		sprite.play(anim)
	_bob_time += delta * bob_speed * TAU
	sprite.position.y = sin(_bob_time) * bob_height
