extends CharacterBody2D


const SPEED = 100.0
const ACCELERATION = 800.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	var direction := Input.get_axis("ui_left", "ui_right")
	handle_acceleration(direction, delta)
	apply_friction(direction, delta)
	update_animations(direction)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()

func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
			coyote_jump_timer.stop()
	elif not is_on_floor():
		if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY/2:
			velocity.y = JUMP_VELOCITY/2

func apply_friction(direction, delta):
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func handle_acceleration(direction, delta):
	if direction != 0:
		velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION * delta)

func update_animations(direction):
	if direction != 0:
		animated_sprite_2d.flip_h = (direction > 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
