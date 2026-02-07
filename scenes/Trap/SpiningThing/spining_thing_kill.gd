extends Node3D

@export var rotation_speed: float = 180.0
@onready var stick: Node3D = $Cone/Stick

func _process(delta: float) -> void:
	stick.rotate_y(deg_to_rad(rotation_speed * delta))
