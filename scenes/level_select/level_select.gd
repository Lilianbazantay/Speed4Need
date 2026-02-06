extends Control
class_name LevelSelect

@onready var current_level: LevelIcon = $LevelIcon

func _ready() -> void:
	$PlayerIcon.global_position = current_level.global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") and current_level.next_up:
		current_level = current_level.next_up
		$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_down") and current_level.next_down:
		current_level = current_level.next_down
		$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_left") and current_level.next_left:
		current_level = current_level.next_left
		$PlayerIcon.global_position = current_level.global_position
	if event.is_action_pressed("ui_right") and current_level.next_right:
		current_level = current_level.next_right
		$PlayerIcon.global_position = current_level.global_position

	if event.is_action_pressed("ui_accept"):
		if not current_level.scene_path:
			print("no scene to load")
			return
		Utils.load_screen_to_scene(current_level.scene_path)
