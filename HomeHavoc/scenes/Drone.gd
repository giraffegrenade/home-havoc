extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const MAX_SPEED = 300
const ACCELERATION = 50

var velocity = Vector2()

func _physics_process(delta):
	velocity.y += GRAVITY
	var friction = false
	
	# Drone movement
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
		$Sprite.flip_h = true
	elif Input.is_action_pressed("ui_up"):
		velocity.y = min(velocity.y + ACCELERATION, MAX_SPEED)
	"""
	else:
		$Sprite.play("Idle")
		friction = true
	"""
	
	velocity.x = lerp(velocity.x, 0, 0.2)
	velocity.y = lerp(velocity.y, 0, 0.2)
	velocity = move_and_slide(velocity, UP)