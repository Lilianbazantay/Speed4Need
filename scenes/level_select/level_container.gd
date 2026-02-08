extends GridContainer

signal ready_to_deploy

func _ready() -> void:
	if (GameRoomsData.roomArray.is_empty()):
		GameRoomsData.loadRooms();
	var iconScene = preload("res://scenes/level_select/level_icon.tscn")
	var index: int = 0;
	for room in GameRoomsData.roomArray:
		var newIcon = iconScene.instantiate();
		newIcon.level_index = index;
		add_child(newIcon);
		index += 1;
	emit_signal("ready_to_deploy")
