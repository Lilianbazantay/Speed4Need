extends Control
class_name LevelSelect

@onready var current_level: LevelIcon = $GridContainer/LevelIcon

func _ready() -> void:
	$PlayerIcon.global_position = current_level.global_position

func _input(event: InputEvent) -> void:
	var idx = current_level.get_index()
	if event.is_action_pressed("ui_up"):
		# if not on upper line
		if not (idx < $GridContainer.columns):
			current_level = $GridContainer.get_child(idx - $GridContainer.columns)
			$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_down"):
		# if not on bottom line
		if not ($GridContainer.get_child_count() - $GridContainer.columns <= idx):
			current_level = $GridContainer.get_child(idx + $GridContainer.columns)
			$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_left"):
		# do not exit container
		if 0 < idx:
			current_level = $GridContainer.get_child(idx - 1)
			$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_right"):
		# do not exit container
		if idx < $GridContainer.get_child_count() - 1:
			current_level = $GridContainer.get_child(idx + 1)
			$PlayerIcon.global_position = current_level.global_position

	if event.is_action_pressed("ui_accept"):
		if not current_level.scene_path:
			print("no scene to load")
			return
		Utils.load_screen_to_scene(current_level.scene_path)
