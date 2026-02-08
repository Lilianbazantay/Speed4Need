extends Node3D

@export var acceleration: float = 10.0
@export var pull_force: float = 50.0
@export var max_distance: float = 100.0

var is_grappling := false
var hook_point: Vector3
var rope_length: float = 0.0

@onready var player: CharacterBody3D = $".."
@onready var cam: Camera3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/RayCast3D
@onready var origin: Marker3D = $Camera3D/Marker3D
@onready var rope: MeshInstance3D = $GrappleRope
@onready var grapple_sound: AudioStreamPlayer3D = $GrappleSound

@onready var cursor := $"../HUD/Cursor"
@onready var cursor_ok := $"../HUD/CursorOk"

func _ready():
	rope.visible = false
	if cursor != null && cursor_ok != null:
		cursor.show()
		cursor_ok.hide()

func _process(delta):
	if Input.is_action_just_pressed("grapple"):
		try_grapple()

	if is_grappling:
		pull_player(delta)
		update_rope()

	if Input.is_action_just_released("grapple"):
		stop_grapple()

	update_cursor_state()


func check_variable():
	return player != null and cam != null and ray != null and origin != null and rope != null


func try_grapple():
	if not check_variable():
		return

	ray.target_position = Vector3(0, 0, -max_distance)
	ray.force_raycast_update()

	if ray.is_colliding():
		hook_point = ray.get_collision_point()
		rope_length = origin.global_position.distance_to(hook_point)
		is_grappling = true
		rope.visible = true

		if grapple_sound != null:
			grapple_sound.play()


func pull_player(delta):
	if not check_variable():
		return

	var to_hook = hook_point - player.global_position
	var dist = to_hook.length()
	var dir = to_hook.normalized()

	var speed_along_rope = player.velocity.dot(dir)
	player.velocity = dir * speed_along_rope

	player.velocity += dir * pull_force * delta
	player.velocity += dir * acceleration * delta

	if dist > rope_length:
		var correction = (dist - rope_length) * 80.0
		player.velocity += dir * correction * delta

	player.move_and_slide()


func update_rope():
	if not check_variable():
		return

	var start_pos = origin.global_position
	var end_pos = hook_point
	var dist = rope_length

	rope.global_position = (start_pos + end_pos) * 0.5
	rope.look_at(end_pos, Vector3.UP)
	rope.rotate_object_local(Vector3.RIGHT, deg_to_rad(90))
	rope.scale = Vector3(1, dist * 0.5, 1)


func stop_grapple():
	is_grappling = false
	rope.visible = false


func _on_area_3d_area_entered(_area: Area3D) -> void:
	stop_grapple()

func update_cursor_state():
	ray.target_position = Vector3(0, 0, -max_distance)
	ray.force_raycast_update()

	if ray.is_colliding():
		cursor.hide()
		cursor_ok.show()
	else:
		cursor.show()
		cursor_ok.hide()
