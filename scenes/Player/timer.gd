extends Control

var time: int = 0

func _ready() -> void:
	if (!PlayerSettings.timerEnabled):
		$Time.hide();

func _process(_delta: float) -> void:
	time = Time.get_ticks_msec()
	$Time.text = "Time : %.2fs" % (time / 1000.0)
	PlayerRecord.timer = time
