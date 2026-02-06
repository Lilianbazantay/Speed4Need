extends Node2D

var is_hide = true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Menu"):
		if is_hide == true:
			show()
			is_hide = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		else:
			hide()
			is_hide = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
