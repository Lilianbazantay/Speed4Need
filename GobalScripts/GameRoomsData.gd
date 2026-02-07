extends Node

class Room:
	var name: String;
	var id: String;
	var scenePath: String;
	var won: bool;
	var bestSpeed: float;
	var bestTime: float;

var prevRoom: Room;

var prevRoomPath: String;

var roomArray: Array;
