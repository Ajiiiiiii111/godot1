extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -900.0

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
var is_jumping = false  # Track jumping state

func _physics_process(delta: float) -> void:
	# Handle animation logic
	if is_on_floor():
		if is_jumping:
			is_jumping = false  # Reset jump state when landing
		if velocity.x != 0:
			sprite_2d.animation = "running"
		else:
			sprite_2d.animation = "default"
	else:
		if is_jumping:
			sprite_2d.animation = "jumping"

	sprite_2d.play()  # Ensure animation plays

	# Apply gravity
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true  # Set jump state
		sprite_2d.animation = "jumping"
		sprite_2d.play()

	# Handle movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite_2d.flip_h = direction < 0  # Flip character
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	move_and_slide()
