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


var prevRoom: Room;

var prevRoomPath: String;

var roomArray: Array[Room];

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
	pass;
