extends Control

func _ready():
	$Keys/CheckBox.button_pressed = PlayerSettings.timerEnabled



func _on_back_to_menu_pressed() -> void:
	saveBindings();
	PlayerSettings.save_settings();
	get_tree().change_scene_to_file("res://scenes/MainMenu/MainMenu.tscn")


func _on_check_box_pressed() -> void:
	PlayerSettings.timerEnabled = !PlayerSettings.timerEnabled;

func saveBindings() -> void:
	var data = {}
	for action in InputMap.get_actions():
		var events = InputMap.action_get_events(action)
		if events.size() > 0 and events[0] is InputEventKey:
			data[action] = events[0].keycode
	var file = FileAccess.open("user://Keybinds.cfg", FileAccess.WRITE)
	file.store_var(data)
