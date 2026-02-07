@tool
extends Control
class_name LevelIcon

@export var level_index: int = 0
var scene_path: String;

func _ready() -> void:
#	$Label.text = "level " + str(level_index)
	if (GameRoomsData.roomArray.is_empty()):
		GameRoomsData.loadRooms();
	if (level_index < GameRoomsData.roomArray.size()):
		scene_path = GameRoomsData.roomArray[level_index].scenePath;
		$Name.text = GameRoomsData.roomArray[level_index].name
		if (GameRoomsData.roomArray[level_index].won):
			$Crown.show();
			$Panel/BT/Label.text = str(GameRoomsData.roomArray[level_index].bestTime) + " S"
			$Panel/HS/Label.text = " %.3fm/S" %GameRoomsData.roomArray[level_index].bestSpeed

func _on_texture_button_pressed() -> void:
	if scene_path == "":
		print("no scene to load")
		return
	GameRoomsData.prevRoomPath = scene_path;
	Utils.load_screen_to_scene(scene_path)
