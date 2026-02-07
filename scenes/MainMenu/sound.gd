extends Panel

var is_effect_active: bool = false;
var is_music_active: bool = false;

func _ready() -> void:
	var prevPos: Vector2;
	prevPos[1] = -5;
	prevPos[0] = 12 + (PlayerSettings.soudEffects * 3);
	$EffectsButtonLine/EffectsButton.set_position(prevPos);
	$EffectsLineEdit.text = "%.02f" % PlayerSettings.soudEffects
	prevPos[0] = 12 + (PlayerSettings.soundMusic * 3);
	$MusicButtonLine/MusicButton.set_position(prevPos);
	$MusicLineEdit.text = "%.02f" % PlayerSettings.soundMusic

	$CheckBox.button_pressed = PlayerSettings.soundEnabled

func _input(event):
	if (!is_effect_active && !is_music_active):
		return;
	if event is InputEventMouseMotion:
		var newPosition = $EffectsButtonLine.get_local_mouse_position();
		if (newPosition[0] < -12):
			newPosition[0] = -12;
		newPosition[1] = -5;
		if (is_effect_active):
			$EffectsButtonLine/EffectsButton.set_position(newPosition)
			PlayerSettings.soudEffects = (newPosition[0] + 12) / 3;
			$EffectsLineEdit.text = "%.02f" % PlayerSettings.soudEffects
		if (is_music_active):
			$MusicButtonLine/MusicButton.set_position(newPosition)
			PlayerSettings.soundMusic = (newPosition[0] + 12) / 3;
			$MusicLineEdit.text = "%.02f" % PlayerSettings.soundMusic




func _on_effects_button_button_down() -> void:
	is_effect_active = true;


func _on_effects_button_button_up() -> void:
	is_effect_active = false;


func _on_music_button_button_down() -> void:
	is_music_active = true;


func _on_music_button_button_up() -> void:
	is_music_active = false;


func _on_check_box_pressed() -> void:
	PlayerSettings.soundEnabled = !PlayerSettings.soundEnabled;
