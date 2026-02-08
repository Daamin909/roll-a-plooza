extends CharacterBody2D

const SPEED := 300.0
const JUMP_VELOCITY := -400.0
const MAX_JUMPS := 2

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var jumps_left := MAX_JUMPS

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps_left = MAX_JUMPS

	# Jump / Double jump
	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

		if jumps_left == 1:
			sprite.play("jump")
		else:
			sprite.play("double_jump")

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	_update_animation()


func _update_animation() -> void:
	# Airborne first (highest priority)
	if not is_on_floor():
		if velocity.y > 0:
			sprite.play("fall")
		return

	# Grounded
	if abs(velocity.x) > 5:
		sprite.play("run")
	else:
		sprite.play("idle")
