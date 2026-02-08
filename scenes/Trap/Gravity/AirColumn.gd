extends Area3D

@export var lift_strength: float = 40.0
@export var max_up_speed: float = 10.0

func _physics_process(_delta):
	var bodies = get_overlapping_bodies()

	for body in bodies:

		if body is RigidBody3D:
			body.apply_central_force(Vector3.UP * lift_strength)

			if body.linear_velocity.y > max_up_speed:
				body.linear_velocity.y = max_up_speed

		# --- CHARACTERBODY3D ---
		elif body is CharacterBody3D:
			var v = body.velocity
			v.y += lift_strength * 0.1
			if v.y > max_up_speed:
				v.y = max_up_speed

			body.velocity = v
