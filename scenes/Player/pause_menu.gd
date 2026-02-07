extends Control

func _ready() -> void:
	$Button.pressed.connect(func():
		Utils.load_screen_to_scene("res://scenes/MainMenu/MainMenu.tscn")
	)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Menu"):
		if not visible:
			show()
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		else:
			hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
