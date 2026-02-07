extends Panel

var is_button_active: bool = false;

func _ready() -> void:
	var prevPos: Vector2;
	prevPos[0] = 12 + (PlayerSettings.sensibility / 100);
	prevPos[1] = -5;
	$ButtonLine/Button.set_position(prevPos);
	$LineEdit.text = "%.4f" % PlayerSettings.sensibility
	pass;

func _input(event):
	if (!is_button_active):
		return;
	if event is InputEventMouseMotion:
		var newPosition = $ButtonLine.get_local_mouse_position();
		if (newPosition[0] < -12):
			newPosition[0] = -12;
		newPosition[1] = -5;
		$ButtonLine/Button.set_position(newPosition)
		PlayerSettings.sensibility = (newPosition[0] + 12) / 100;
		$LineEdit.text = "%.4f" % PlayerSettings.sensibility

func _on_button_button_down() -> void:
	is_button_active = true;
	pass # Replace with function body.


func _on_button_button_up() -> void:
	is_button_active = false;
	pass # Replace with function body.


func _on_line_edit_text_submitted(new_text: String) -> void:
	var test: float = PlayerSettings.sensibility;
	if (new_text.is_valid_float()):
		test = new_text.to_float();
	var prevPos: Vector2;
	prevPos[0] = 12 + (test / 100);
	prevPos[1] = -5;
	$ButtonLine/Button.set_position(prevPos);
	PlayerSettings.sensibility = test
