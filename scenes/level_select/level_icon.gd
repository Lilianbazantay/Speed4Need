@tool
extends Control
class_name LevelIcon

@export var level_index: int = 0
var scene_path: String

func _ready() -> void:
	if (GameRoomsData.roomArray.is_empty()):
		GameRoomsData.loadRooms()
	if (level_index < GameRoomsData.roomArray.size()):
		scene_path = GameRoomsData.roomArray[level_index].scenePath
		$Name.text = GameRoomsData.roomArray[level_index].name
		if (GameRoomsData.roomArray[level_index].won):
			$Crown.show();
			$Panel/BT/Label.text = str(GameRoomsData.roomArray[level_index].bestTime) + " S"
			$Panel/HS/Label.text = " %.3fm/S" %GameRoomsData.roomArray[level_index].bestSpeed
#			$TextureButton.set_position([0, 0])
	print("level ", level_index, " ready at ", global_position)

func _on_texture_button_pressed() -> void:
	GameRoomsData.prevRoomPath = scene_path
	Utils.load_screen_to_scene(scene_path)
