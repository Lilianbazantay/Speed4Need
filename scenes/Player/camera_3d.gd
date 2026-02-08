extends Camera3D

var shake_strength: float = 0.0
var shake_duration: float = 0.0
var shake_timer: float = 0.0

var noise := FastNoiseLite.new()
var base_local_pos: Vector3
var base_local_rot: Vector3

func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	base_local_pos = position
	base_local_rot = rotation

func shake_for(seconds: float, strength: float = 1.0):
	shake_duration = seconds
	shake_strength = strength
	shake_timer = 0.0

func _process(delta: float) -> void:
	if shake_timer < shake_duration:
		shake_timer += delta
		var t := shake_timer / shake_duration
		var intensity := shake_strength * (1.0 - t)

		var time := Time.get_ticks_msec() * 0.2

		var pos_offset := Vector3(
			noise.get_noise_1d(time) * intensity * 0.03,
			noise.get_noise_1d(time + 1000) * intensity * 0.03,
			noise.get_noise_1d(time + 2000) * intensity * 0.03
		)

		var rot_offset := Vector3(
			noise.get_noise_1d(time + 3000) * intensity * 0.15,
			noise.get_noise_1d(time + 4000) * intensity * 0.15,
			noise.get_noise_1d(time + 5000) * intensity * 0.15
		)

		position = base_local_pos + pos_offset
		rotation = base_local_rot + rot_offset
	else:
		position = base_local_pos
		rotation = base_local_rot
