extends Node3D

@export var explosion_force := 50.0
@onready var Explosion : AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var RedParticule : GPUParticles3D = $RedParticule
@onready var GreyParticule : GPUParticles3D = $GreyParticule

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent() is CharacterBody3D:
		var player := area.get_parent()

		var direction = (player.global_position - global_position).normalized()
		player.velocity += direction * explosion_force

		var cam = player.get_node("Head/Camera3D")
		if cam != null :
			print("Has camera")
			cam.shake_for(0.2, 2.5)

		if Explosion != null :
			Explosion.play()
		if RedParticule != null && GreyParticule != null :
			RedParticule.emitting = true
			GreyParticule.emitting = true
		await get_tree().create_timer(1.5).timeout
		queue_free()
