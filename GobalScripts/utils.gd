extends Node

func load_screen_to_scene(target: String, min_load_time: float = 0.5) -> void:
	var loading_screen = preload("res://scenes/loading/loading_screen.tscn").instantiate()
	loading_screen.scene_path = target
	loading_screen.min_load_time = min_load_time
	get_tree().current_scene.add_child(loading_screen)
