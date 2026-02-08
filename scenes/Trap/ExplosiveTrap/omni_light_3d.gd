extends OmniLight3D

var is_activated = false

func _process(delta: float) -> void:
	if is_activated == true :
		self.omni_range += 1 * delta

func activate():
	is_activated = true

func disable():
	is_activated = false
