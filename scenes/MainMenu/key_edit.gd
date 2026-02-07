extends Label

var keyStr: String;
var prevStr: String;
var waitRebind: bool = false

func _ready():
	keyStr = $".".text;
	var events = InputMap.action_get_events(keyStr)
	if !events.is_empty() && events[0] is InputEventKey:
		$Rebind.text = OS.get_keycode_string(events[0].keycode)
	else:
		if (events.is_empty()):
			$Rebind.text = "Unbound"
		else:
			$Rebind.text = "Mouse/Joypad"
	prevStr = $Rebind.text


func _input(event: InputEvent) -> void:
	if (!waitRebind):
		return;
	if (event.is_pressed()
		&& event is InputEventKey
		|| event is InputEventMouseButton
		|| event is InputEventJoypadButton):
		waitRebind = false;
		if (event is InputEventMouseButton
			|| event is InputEventJoypadButton):
			$Rebind.text = "Mouse/Joypad"
		else:
			if (event.keycode == KEY_ESCAPE):
				$Rebind.text = prevStr;
				return;
			$Rebind.text = OS.get_keycode_string(event.keycode)
		prevStr = $Rebind.text;
		InputMap.action_erase_events(keyStr)
		InputMap.action_add_event(keyStr, event);

func _on_rebind_pressed() -> void:
	$Rebind.text = "Unbound"
	waitRebind = true;
