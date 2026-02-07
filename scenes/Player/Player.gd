extends CharacterBody3D

var move_speed = 10.0
var sprint_speed = 10.0
var gravity = 10.0
var mouse_sensitivity = 0.002

var jump_force_idle = 5.0
var jump_force_walking = 3.0
var wall_jump_force = 8.0
var jump_force_walking_boost = 10.0

var wall_jump_max = 2
var wall_jump_count = 2

var is_crouching = false
var friction_crouch_boost = 2.5

var is_walking = false
var friction = 2.5

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var break_sound: AudioStreamPlayer3D = $BreakSound

var y_rot := 0.0
var x_rot := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_mouse(event)

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	_handle_movement(delta)
	move_and_slide()

	# --- SOUND FIX ---
	# Le son joue quand :
	# - tu es au sol
	# - tu es accroupi
	# - tu bouges (vitesse > 0.5)
	if is_on_floor() and Input.is_action_pressed("crouch") and velocity.length() > 0.5:
		if not break_sound.playing:
			break_sound.play()
	else:
		if break_sound.playing:
			break_sound.stop()
	# --- END SOUND FIX ---

func _handle_movement(delta: float) -> void:
	var input_dir := Vector2.ZERO

	# Input
	if is_crouching == false:
		if Input.is_action_pressed("move_forward"):
			is_walking = true
			input_dir.y += 1
		if Input.is_action_pressed("move_backward"):
			is_walking = true
			input_dir.y -= 1
		if Input.is_action_pressed("move_left"):
			is_walking = true
			input_dir.x -= 1
		if Input.is_action_pressed("move_right"):
			is_walking = true
			input_dir.x += 1
		if Input.is_action_just_released("move_forward") \
		or Input.is_action_just_released("move_backward") \
		or Input.is_action_just_released("move_left") \
		or Input.is_action_just_released("move_right"):
			is_walking = false
		input_dir = input_dir.normalized()

	# Camera direction
	var forward := -camera.global_transform.basis.z
	var right := camera.global_transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	var direction := (forward * input_dir.y) + (right * input_dir.x)
	velocity.x += direction.x * move_speed * delta
	velocity.z += direction.z * move_speed * delta

	# Ground
	if is_on_floor():
		if wall_jump_count < wall_jump_max:
			wall_jump_count = wall_jump_max

		if Input.is_action_just_pressed("jump"):
			if velocity.x == 0 and velocity.z == 0:
				velocity.y = jump_force_idle
			if velocity.x != 0:
				velocity.y += jump_force_walking
			if velocity.z != 0:
				velocity.y += jump_force_walking
			if velocity.x < velocity.z:
				velocity.x += direction.x * jump_force_walking_boost * delta
			else:
				velocity.z += direction.x * jump_force_walking_boost * delta
		else:
			velocity.y = 0.0

		# FRICTION
		if is_walking == false:
			if velocity.x != 0:
				if velocity.x < 0:
					velocity.x += friction * delta
				if velocity.x > 0:
					velocity.x -= friction * delta
			if velocity.x < friction and velocity.x > -friction:
				velocity.x = 0.0

			if velocity.z != 0:
				if velocity.z < 0:
					velocity.z += move_speed * delta
				if velocity.z > 0:
					velocity.z -= move_speed * delta
			if velocity.z < friction and velocity.z > -friction:
				velocity.z = 0.0

	# Wall jump
	if is_on_wall() and wall_jump_count != 0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = wall_jump_force
			wall_jump_count -= 1

	$ATH/RichTextLabel.text = "SPEED : " + str(abs(velocity.z))

	# Crouch
	if Input.is_action_just_pressed("crouch"):
		is_crouching = true
		is_walking = false
		friction += friction_crouch_boost
		scale.y *= 0.5
		$Head/Camera3D.scale *= 2

	if Input.is_action_just_released("crouch"):
		is_crouching = false
		friction -= friction_crouch_boost
		scale.y *= 2
		$Head/Camera3D.scale *= 0.5

func _handle_gravity(delta: float) -> void:
	if not is_on_floor() and is_on_wall():
		velocity.y -= gravity * delta * 0.3
	if not is_on_floor() and not is_on_wall():
		velocity.y -= gravity * delta

func _handle_mouse(event: InputEventMouseMotion) -> void:
	y_rot -= event.relative.x * mouse_sensitivity
	x_rot -= event.relative.y * mouse_sensitivity

	x_rot = clamp(x_rot, deg_to_rad(-90), deg_to_rad(90))

	rotation.y = y_rot
	head.rotation.x = x_rot
