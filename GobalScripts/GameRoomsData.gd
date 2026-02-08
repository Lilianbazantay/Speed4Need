extends Node

class Room:
	var name: String;
	var index: int;
	var scenePath: String;
	var won: bool;
	var bestSpeed: float;
	var bestTime: float;
	func _init(_name: String, _index: int, _scenePath: String):
		if (_name.ends_with(".tscn")):
			_name = _name.erase(_name.length() -5, 5)
		name = _name;
		index = _index;
		scenePath = _scenePath;
		won = false;
		bestSpeed = -1;
		bestTime = -1;
	func to_dict() -> Dictionary:
		return {
			"won": won,
			"bestSpeed": bestSpeed,
			"bestTime": bestTime
		};
	func from_dict(data: Dictionary):
		print("loading from dict: ", name, " / ", data.won);
		won = data.won;
		bestSpeed = data.bestSpeed;
		bestTime = data.bestTime;


var roomArray: Array[Room];


var prevRoom: Room;

var prevRoomPath: String;


func loadRooms():
	if (!roomArray.is_empty()):
		roomArray.clear();
	var levelPath = "res://scenes/Level"
	var dir = DirAccess.open(levelPath)
	if (dir == null):
		return;
#	var folderName := dir.get_next()
	var dirNames: PackedStringArray = dir.get_directories();
	var index: int = 0;
	for subName in dirNames:
		dir = DirAccess.open(levelPath + "/" + subName)
		var correct = false;
		for filename in dir.get_files():
			if (correct || !filename.ends_with(".tscn")):
				continue;
			var newRoom: Room = Room.new(filename, index,
				levelPath + '/' + subName + '/' + filename)
			roomArray.push_back(newRoom)
			index += 1;
			correct = true;
			pass;
	for room in roomArray:
		print(room.index, " | ", room.name, " | ", room.scenePath)
	print("Room Array: ", roomArray.size())
	loadFromFile();
	pass;



# LOAD / SAVE SYSTEM

var SETTINGS_PATH : String = "user://roomScore.save"

func saveToFile():
	print("saving files")
	var roomsData: Array = []

	for room in roomArray:
		roomsData.append(room.to_dict())

	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(roomsData))
	file.close()


func loadFromFile():
	print("loading files")
	if  (!FileAccess.file_exists(SETTINGS_PATH)):
		return
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(content)
	if parsed == null:
		push_error("Failed to parse rooms save file")
		return
	var index: int = 0;
	for room_dict in parsed:
		if (index >= roomArray.size()):
			print("Too large: ", index)
			return;
		roomArray[index].from_dict(room_dict)
		index += 1;
