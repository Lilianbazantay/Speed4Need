extends Control

func _ready() -> void:
	PlayerSettings.load_settings();

func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select/level_select.tscn")

func _on_button_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu/Settings.tscn")

func _on_button_quit_pressed() -> void:
	get_tree().quit()

func load_bindings() -> void:
	if not FileAccess.file_exists("user://keybinds.cfg"):
		return
	var file = FileAccess.open("user://keybinds.cfg", FileAccess.READ)
	if (file != OK):
		return;
	var data = file.get_var()
	for action in data.keys():
		var ev = InputEventKey.new()
		ev.keycode = data[action]
		InputMap.action_erase_events(action);
		InputMap.action_add_event(action, ev);
