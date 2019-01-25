extends KinematicBody2D

export (int) var player_num

const UP = Vector2(0, -1)
const GRAVITY = 5
const MAX_SPEED = 2000
const ACCELERATION = 40

var screensize
var velocity = Vector2()

func _ready():
	screensize = get_viewport().size
	if player_num == 1:
		$P1.show()
		$P2.hide()
	else:
		$P2.show()
		$P1.hide()

func _physics_process(delta):
	velocity.y += GRAVITY
	var right_input
	var left_input
	var up_input
	var grab_input
	
	# Setting up two player input
	if player_num == 1:
		right_input = "ui_right"
		left_input = "ui_left"
		up_input = "ui_up"
		grab_input = "ui_down"
	else:
		right_input = "ui_right2"
		left_input = "ui_left2"
		up_input = "ui_up2"
		grab_input = "ui_down2"
		
	if Input.is_action_pressed(right_input):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
	elif Input.is_action_pressed(left_input):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
	elif Input.is_action_pressed(up_input):
		velocity.y = max(velocity.y - ACCELERATION, -MAX_SPEED)
	
	if position.y >= screensize.y - 70:
		velocity.y = -5
	if position.y <= 0:
		velocity.y = 5
	if position.x >= screensize.x:
		velocity.x = -5
	if position.x <= 0:
		velocity.x = 5
	
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y - 70)
	
	velocity = move_and_slide(velocity, UP)