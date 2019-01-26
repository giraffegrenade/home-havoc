extends RigidBody2D

var connected_to_drone

func _physics_process(delta):
	if connected_to_drone:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false