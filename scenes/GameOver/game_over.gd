extends Control

@onready var looser_sound : AudioStreamPlayer2D = $LooserSound

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	if looser_sound != null :
		looser_sound.play()

func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu/MainMenu.tscn")

func _on_rage_quit_pressed() -> void:
	get_tree().quit()
