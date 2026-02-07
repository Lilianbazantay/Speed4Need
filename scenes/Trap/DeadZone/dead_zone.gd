extends Node3D

func _on_area_3d_area_entered(_area: Area3D) -> void:
	get_tree().change_scene_to_file("res://scenes/GameOver/GameOver.tscn")
