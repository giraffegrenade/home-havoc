extends RigidBody2D

var connected_to_drone
const BLOCK_TYPES = ["SmallBlock", "LargeBlock"]

func _ready():
	block_type = BLOCK_TYPES[0] # random number
	position = Vector2(rand_range(get_viewport().size.x / 3, get_viewport().size.x * 2 / 3), 10)

func _physics_process(delta):
	if connected_to_drone:
		$SmallBlockCollision.disabled = true
	else:
		$SmallBlockCollision.disabled = false