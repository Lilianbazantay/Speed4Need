extends MarginContainer

var time : float = 0.0

func _on_timer_timeout() -> void:
	time += 0.1
	$RichTextLabel2.text = "Timer : " + str(time) + " s"
	PlayerRecord.timer = time
