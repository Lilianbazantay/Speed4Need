extends Control

var time: float = 0.0

func _on_timer_timeout() -> void:
	time += 0.1
	$Time.text = "Time : %.2fs" % time
	PlayerRecord.timer = time
