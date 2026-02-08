extends Control

var start: int = 0
var time: int = 0

func _ready() -> void:

	start = Time.get_ticks_msec()
	if (!PlayerSettings.timerEnabled):
		$Time.hide();


func _process(_delta: float) -> void:
	time = Time.get_ticks_msec()
	$Time.text = "Time : %.2fs" % ((time - start) / 1000.0)
	PlayerRecord.timer = time - start
