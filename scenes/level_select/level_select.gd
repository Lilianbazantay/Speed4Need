extends Control
class_name LevelSelect

@onready var current_level: LevelIcon
var isReady: bool = false;

func _on_level_container_ready_to_deploy() -> void:
	current_level = $LevelContainer.get_children()[0]
	$PlayerIcon.global_position = current_level.global_position
	isReady = true;
	pass;

func _input(event: InputEvent) -> void:
	if (!isReady):
		return;
	var idx = current_level.get_index()
	if event.is_action_pressed("ui_up"):
		# if not on upper line
		if not (idx < $LevelContainer.columns):
			current_level = $LevelContainer.get_child(idx - $LevelContainer.columns)
			$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_down"):
		# if not on bottom line
		if not ($LevelContainer.get_child_count() - $LevelContainer.columns <= idx):
			current_level = $LevelContainer.get_child(idx + $LevelContainer.columns)
			$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_left"):
		# do not exit container
		if 0 < idx:
			current_level = $LevelContainer.get_child(idx - 1)
			$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_right"):
		# do not exit container
		if idx < $LevelContainer.get_child_count() - 1:
			current_level = $LevelContainer.get_child(idx + 1)
			$PlayerIcon.global_position = current_level.global_position

	if event.is_action_pressed("ui_accept"):
		GameRoomsData.prevRoomPath = current_level.scene_path
		Utils.load_screen_to_scene(current_level.scene_path)


func _on_button_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu/MainMenu.tscn")
