extends CharacterBody3D

@export_category("Movement")
@export var speed: float = 8.0
@export var acceleration: float = 20.0
@export var friction: float = 25.0

@export var air_acceleration:float = 2.0
@export var air_friction: float = 1.0

# Gravity
const gravity: float = 9.81

# Jump
@export_category("Jump")
@export var jump_force_walking = 5.0
@export var jump_force_walking_boost = 5.0
@export var jump_force_idle = 3.0

@export var wall_jump_force = 8.0
@export var wall_jump_max = 2
var wall_jump_count = 0

# Crouch
var is_crouching = false
var friction_crouch_boost = 2.5
var crouch_scale = 0.5

# Camera
var y_rot := 0.0
var x_rot := 0.0

@onready var original_collision_height: float

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	PlayerRecord.max_speed = 0.0
	original_collision_height = $Collision.shape.height

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_mouse_look(event)

func _process(delta: float) -> void:
	_handle_controller_look(delta)
	_apply_camera_rotation()
	if is_on_wall_only():
		$HUD/Sprite2D.frame = 2
		return
	if is_on_floor():
		if is_crouching:
			$HUD/Sprite2D.frame = 3
			return
		$HUD/Sprite2D.frame = 0
		return
	$HUD/Sprite2D.frame = 4

func _physics_process(delta: float) -> void:
	_handle_gravity(delta)
	_handle_movement(delta)
	move_and_slide()
	_handle_break_sound()

func _handle_mouse_look(event: InputEventMouseMotion) -> void:
	y_rot -= event.relative.x * PlayerSettings.sensibility / 1000
	x_rot -= event.relative.y * PlayerSettings.sensibility / 1000
	x_rot = clamp(x_rot, deg_to_rad(-90), deg_to_rad(90))

func _handle_controller_look(delta: float) -> void:
	var controller_input_x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	var controller_input_y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	y_rot += controller_input_x * delta * PlayerSettings.sensibility / 1000
	x_rot += controller_input_y * delta * PlayerSettings.sensibility / 1000
	x_rot = clamp(x_rot, deg_to_rad(-90), deg_to_rad(90))

func _apply_camera_rotation() -> void:
	rotation.y = y_rot
	$Head.rotation.x = x_rot

func _handle_movement(delta: float) -> void:
	var input_dir = _get_input_direction()
	var direction = _calculate_movement_direction(input_dir)
	_apply_acceleration(direction, delta)
	_handle_floor_movement(direction)
	_handle_wall_jump()
	_handle_crouch()
	_update_speed_display()

func _get_input_direction() -> Vector2:
	if is_crouching:
		return Vector2.ZERO

	var input_dir = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	return input_dir

func _calculate_movement_direction(input_dir: Vector2) -> Vector3:
	var forward := -global_transform.basis.z
	var right := global_transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	return (forward * input_dir.y) + (right * input_dir.x)

func _apply_acceleration(direction: Vector3, delta: float) -> void:
	if is_on_floor():
		# GROUND LOGIC: Snappy and limited to max speed
		var target_velocity = Vector3.ZERO
		if direction.length() > 0:
			target_velocity = direction * speed
		velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)
	else:
		# AIR LOGIC: Floaty and not limited by max speed
		if direction.length() > 0:
			# We add velocity directly so we can go faster than 'speed'
			velocity.x += direction.x * air_acceleration * delta
			velocity.z += direction.z * air_acceleration * delta
		else:
			# We use low air_friction so we barely slow down
			velocity.x = move_toward(velocity.x, 0.0, air_friction * delta)
			velocity.z = move_toward(velocity.z, 0.0, air_friction * delta)

func _handle_floor_movement(direction: Vector3) -> void:
	if not is_on_floor():
		return
	_reset_wall_jump_count()
	_handle_jump(direction)

func _reset_wall_jump_count() -> void:
	wall_jump_count = wall_jump_max

func _handle_jump(direction: Vector3) -> void:
	if Input.is_action_just_pressed("jump"):
		var is_moving = velocity.x != 0 or velocity.z != 0
		if is_moving:
			velocity.y = jump_force_walking
			velocity.x += direction.x * jump_force_walking_boost
			velocity.z += direction.z * jump_force_walking_boost
		else:
			velocity.y = jump_force_idle

func _handle_wall_jump() -> void:
	if is_on_wall() and not is_on_floor() and wall_jump_count != 0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = wall_jump_force
			var wall_normal = get_wall_normal()
			velocity.x += wall_normal.x * wall_jump_force
			velocity.z += wall_normal.z * wall_jump_force
			wall_jump_count -= 1

func _handle_crouch() -> void:
	if Input.is_action_just_pressed("crouch"):
		is_crouching = true
		friction += friction_crouch_boost
		$Collision.shape.height = original_collision_height * crouch_scale
		$Collision.position.y = original_collision_height * crouch_scale / 2
		$Head.position.y = original_collision_height * crouch_scale
	if Input.is_action_just_released("crouch") and _can_uncrouch():
		is_crouching = false
		friction -= friction_crouch_boost
		$Collision.shape.height = original_collision_height
		$Collision.position.y = original_collision_height / 2
		$Head.position.y = original_collision_height * 0.75

func _can_uncrouch() -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = $Collision.shape.duplicate()
	query.shape.height = original_collision_height
	query.transform = global_transform.translated(Vector3(0, original_collision_height / 2, 0))
	query.collision_mask = collision_mask
	query.exclude = [self]
	var result = space_state.intersect_shape(query, 1)
	return result.is_empty()

func _update_speed_display() -> void:
	var horizontal_speed = Vector2(velocity.x, velocity.z).length()
	if horizontal_speed > PlayerRecord.max_speed:
		PlayerRecord.max_speed = horizontal_speed
	$HUD/Speed.text = "Speed: %.2f" % horizontal_speed

func _handle_break_sound() -> void:
	var horizontal_speed = Vector2(velocity.x, velocity.z).length()
	if is_on_floor() and Input.is_action_pressed("crouch") and horizontal_speed > 0.5:
		if not $BreakSound.playing:
			$BreakSound.play()
	else:
		if $BreakSound.playing:
			$BreakSound.stop()

func _handle_gravity(delta: float) -> void:
	if not is_on_floor() and is_on_wall():
		velocity.y -= gravity * delta * 0.3
	if not is_on_floor() and not is_on_wall():
		velocity.y -= gravity * delta
