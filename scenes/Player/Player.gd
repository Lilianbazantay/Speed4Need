extends CharacterBody3D

@export_category("Movement")
@export var speed: float = 8.0
var max_speed: float
@export var sprint_boost: float = 10
var is_sprinting: bool = false
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

@export_category("Slide")
var is_sliding = false
@export var slide_duration = 0.6
var slide_timer = 0.0
@export var slide_speed_boost = 1.5
@export var slide_min_speed = 3.0
var slide_scale = 0.25

# Camera
var y_rot := 0.0
var x_rot := 0.0

@onready var original_collision_height: float
@onready var original_area_collision_height: float
@onready var original_pos: Vector3 = global_position


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	PlayerRecord.max_speed = 0.0
	max_speed = speed
	original_collision_height = $Collision.shape.height
	original_area_collision_height = $Area3D/CollisionShape3D.shape.height

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_mouse_look(event)
	if event is InputEventKey:
		if event.keycode == KEY_SHIFT && event.pressed:
			is_sprinting = true

func _process(delta: float) -> void:
	handle_controller_look(delta)
	apply_camera_rotation()
	if global_position.y < -100:
		global_position = original_pos
		velocity = Vector3.ZERO
	if is_on_wall_only():
		$HUD/Sprite2D.frame = 2
		return
	if is_on_floor():
		if is_sliding:
			$HUD/Sprite2D.frame = 3
			return
		if is_sprinting:
			$HUD/Sprite2D.frame = 1
			return
		$HUD/Sprite2D.frame = 0
		return
	$HUD/Sprite2D.frame = 4

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_slide(delta)
	handle_movement(delta)
	move_and_slide()
	handle_break_sound()

func handle_mouse_look(event: InputEventMouseMotion) -> void:
	y_rot -= event.relative.x * PlayerSettings.sensibility / 1000
	x_rot -= event.relative.y * PlayerSettings.sensibility / 1000
	x_rot = clamp(x_rot, deg_to_rad(-90), deg_to_rad(90))

func handle_controller_look(delta: float) -> void:
	var controller_input_x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	var controller_input_y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	y_rot += controller_input_x * delta * PlayerSettings.sensibility / 1000
	x_rot += controller_input_y * delta * PlayerSettings.sensibility / 1000
	x_rot = clamp(x_rot, deg_to_rad(-90), deg_to_rad(90))

func apply_camera_rotation() -> void:
	rotation.y = y_rot
	$Head.rotation.x = x_rot

func handle_movement(delta: float) -> void:
	var input_dir = get_input_direction()
	if is_sprinting:
		is_sprinting = false
		max_speed += sprint_boost # Voluntary bug, do not change (literally the goal of this game)
	var direction = calculate_movement_direction(input_dir)
	apply_acceleration(direction, delta)
	handle_floor_movement(direction)
	handle_wall_jump()
	update_speed_display()

func get_input_direction() -> Vector2:
	if is_sliding:
		return Vector2.ZERO

	var input_dir = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	return input_dir

func calculate_movement_direction(input_dir: Vector2) -> Vector3:
	var forward := -global_transform.basis.z
	var right := global_transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()
	return (forward * input_dir.y) + (right * input_dir.x)

func apply_acceleration(direction: Vector3, delta: float) -> void:
	if is_on_floor():
		if is_sliding:
			return
		var target_velocity = Vector3.ZERO
		if direction.length() > 0:
			target_velocity = direction * max_speed
		else:
			max_speed = speed
		velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
		velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)
	else:
		if direction.length() > 0:
			velocity.x += direction.x * air_acceleration * delta
			velocity.z += direction.z * air_acceleration * delta
		else:
			velocity.x = move_toward(velocity.x, 0.0, air_friction * delta)
			velocity.z = move_toward(velocity.z, 0.0, air_friction * delta)

func handle_floor_movement(direction: Vector3) -> void:
	if not is_on_floor():
		return
	reset_wall_jump_count()
	handle_jump(direction)

func reset_wall_jump_count() -> void:
	wall_jump_count = wall_jump_max

func handle_jump(direction: Vector3) -> void:
	if Input.is_action_just_pressed("jump"):
		var is_moving = velocity.x != 0 or velocity.z != 0
		if is_moving:
			velocity.y = jump_force_walking
			velocity.x += direction.x * jump_force_walking_boost
			velocity.z += direction.z * jump_force_walking_boost
		else:
			velocity.y = jump_force_idle

func handle_wall_jump() -> void:
	if is_on_wall() and not is_on_floor() and wall_jump_count != 0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = wall_jump_force
			var wall_normal = get_wall_normal()
			velocity.x += wall_normal.x * wall_jump_force
			velocity.z += wall_normal.z * wall_jump_force
			wall_jump_count -= 1

func handle_slide(delta: float) -> void:
	if is_sliding:
		slide_timer -= delta
		if slide_timer <= 0 or not is_on_floor():
			end_slide()
		return
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		var horizontal_speed = Vector2(velocity.x, velocity.z).length()
		if horizontal_speed >= slide_min_speed:
			start_slide()

func start_slide() -> void:
	is_sliding = true
	slide_timer = slide_duration
	var horizontal_velocity = Vector2(velocity.x, velocity.z) * slide_speed_boost
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.y
	$Collision.shape.height = original_collision_height * slide_scale
	$Collision.position.y = original_collision_height * slide_scale / 2
	$Head.position.y = original_collision_height * slide_scale
	$Area3D/CollisionShape3D.shape.height = original_area_collision_height * slide_scale
	$Area3D/CollisionShape3D.position.y = original_area_collision_height * slide_scale / 2

func end_slide() -> void:
	if not can_uncrouch():
		return
	is_sliding = false
	$Collision.shape.height = original_collision_height
	$Collision.position.y = original_collision_height / 2
	$Head.position.y = original_collision_height * 0.75
	$Area3D/CollisionShape3D.shape.height = original_area_collision_height
	$Area3D/CollisionShape3D.position.y = original_area_collision_height / 2

func can_uncrouch() -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = $Collision.shape.duplicate()
	query.shape.height = original_collision_height
	query.transform = global_transform.translated(Vector3(0, original_collision_height / 2, 0))
	query.collision_mask = collision_mask
	query.exclude = [self]
	var result = space_state.intersect_shape(query, 1)
	return result.is_empty()

func update_speed_display() -> void:
	var horizontal_speed = Vector2(velocity.x, velocity.z).length()
	if horizontal_speed > PlayerRecord.max_speed:
		PlayerRecord.max_speed = horizontal_speed
	$HUD/Speed.text = "Speed: %.2f" % horizontal_speed

func handle_break_sound() -> void:
	if is_sliding:
		if not $BreakSound.playing:
			$BreakSound.play()
	else:
		if $BreakSound.playing:
			$BreakSound.stop()

func handle_gravity(delta: float) -> void:
	if not is_on_floor() and is_on_wall():
		velocity.y -= gravity * delta * 0.3
	if not is_on_floor() and not is_on_wall():
		velocity.y -= gravity * delta
