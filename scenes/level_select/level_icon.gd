@tool
extends Control
class_name LevelIcon

@export var level_index: int = 0
@export_file("*.tscn") var scene_path: String
@export var next_up: LevelIcon
@export var next_down: LevelIcon
@export var next_left: LevelIcon
@export var next_right: LevelIcon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "level " + str(level_index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$Label.text = "level " + str(level_index)

func _on_button_pressed() -> void:
	Utils.load_screen_to_scene(scene_path)
