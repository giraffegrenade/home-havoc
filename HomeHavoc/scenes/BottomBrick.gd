extends RigidBody2D

var connected_to_drone

func _ready():
	position = Vector2(rand_range(get_viewport().size.x / 3, get_viewport().size.x * 2 / 3), 10)

func _physics_process(delta):
	if connected_to_drone:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false