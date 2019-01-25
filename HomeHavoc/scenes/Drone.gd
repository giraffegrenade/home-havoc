extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 5
const MAX_SPEED = 2000
const ACCELERATION = 40

var velocity = Vector2()

func _physics_process(delta):
	velocity.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
		$Sprite.flip_h = true
	elif Input.is_action_pressed("ui_up"):
		velocity.y = max(velocity.y - ACCELERATION, -MAX_SPEED)
	
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
		
	velocity = move_and_slide(velocity, UP)