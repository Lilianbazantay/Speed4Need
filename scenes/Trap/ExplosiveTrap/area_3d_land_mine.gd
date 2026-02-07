extends Area3D

@onready var bip_sound: AudioStreamPlayer3D = $"../BipSound"

func _on_area_entered(_area: Area3D) -> void:
	print("AREA ENTERED")
	if bip_sound != null:
		print("PLAY")
		bip_sound.play()
