extends Control

@onready var winner_sound : AudioStreamPlayer2D = $WinnerSound
@onready var max_speed : RichTextLabel = $MaxSpeedDisplay
@onready var timer : RichTextLabel = $TimerDisplay

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	print("WIN")
	if winner_sound != null :
		winner_sound.play()
	if max_speed != null && timer != null :
		max_speed.text = "Max Speed : %.2f" % PlayerRecord.max_speed
		timer.text = "Timer          : %.2f" % (PlayerRecord.timer / 1000.0)
		print("Size: ", GameRoomsData.roomArray.size())
		print("pPath: ", GameRoomsData.prevRoomPath)
		for room in GameRoomsData.roomArray:
			print("TestPath: ", room.scenePath)
			if (GameRoomsData.prevRoomPath == room.scenePath):
				print("Saving data !")
				room.bestSpeed = PlayerRecord.max_speed;
				room.bestTime = (PlayerRecord.timer / 1000.0)
				room.won = true;
				break;


func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu/MainMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
