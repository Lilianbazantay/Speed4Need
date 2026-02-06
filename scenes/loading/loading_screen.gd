extends Control

@export var min_load_time: float = 0.5
@export_file("*.tscn") var scene_path: String

func _ready() -> void:
	ResourceLoader.load_threaded_request(scene_path)

func _process(delta: float) -> void:
	if ResourceLoader.load_threaded_get_status(scene_path) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		await get_tree().create_timer(min_load_time).timeout
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(scene_path)
		get_tree().change_scene_to_packed(new_scene)
