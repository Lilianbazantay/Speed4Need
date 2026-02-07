extends Control

var time: float = 0.0

func _ready() -> void:
	if (!PlayerSettings.timerEnabled):
		$Time.hide();

func _process(_delta: float) -> void:
	time = Time.get_ticks_msec()
	$Time.text = "Time : %.2fs" % time
	PlayerRecord.timer = time
