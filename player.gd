extends CharacterBody2D

@export var movement_data : PlayerMovementData

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	var direction := Input.get_axis("ui_left", "ui_right")
	handle_acceleration(direction, delta)
	apply_friction(direction, delta)
	apply_air_resistance(direction, delta)
	update_animations(direction)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * movement_data.gravity_scale * delta

func handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = movement_data.jump_velocity
			coyote_jump_timer.stop()
	elif not is_on_floor():
		if Input.is_action_just_released("ui_accept") and velocity.y < movement_data.jump_velocity/2:
			velocity.y = movement_data.jump_velocity/2

func apply_friction(direction, delta):
	if direction == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_air_resistance(direction, delta):
	if direction == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)

func handle_acceleration(direction, delta):
	if direction != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * direction, movement_data.acceleration * delta)

func update_animations(direction):
	if direction != 0:
		animated_sprite_2d.flip_h = (direction > 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
