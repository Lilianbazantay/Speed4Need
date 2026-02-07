extends Control

func _ready():
	$Keys/CheckBox.button_pressed = PlayerSettings.timerEnabled



func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu/MainMenu.tscn")


func _on_check_box_pressed() -> void:
	PlayerSettings.timerEnabled = !PlayerSettings.timerEnabled;
