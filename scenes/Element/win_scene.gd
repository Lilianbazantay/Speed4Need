extends Control

@onready var winner_sound : AudioStreamPlayer2D = $WinnerSound

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	if winner_sound != null :
		winner_sound.play()

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu/MainMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
