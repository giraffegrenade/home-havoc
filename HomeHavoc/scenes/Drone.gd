extends KinematicBody2D

export (int) var player_num

const UP = Vector2(0, -1)
const GRAVITY = 5
const MAX_SPEED = 1000
const ACCELERATION = 30
const MAX_ROT = PI/4
const ROT_RATE = 0.05
const MAX_HEALTH = 100

var screensize
var velocity = Vector2()
var in_grab_range = false
var current_grabbed_block
var currently_grabbing = false
var health = MAX_HEALTH
var taking_damage = false

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
	var x_left_limit
	var x_right_limit
	
	# Setting up two player input
	if player_num == 1:
		right_input = "ui_right"
		left_input = "ui_left"
		up_input = "ui_up"
		grab_input = "ui_down"
		x_left_limit = screensize.x / 3
		x_right_limit = 0
	else:
		right_input = "ui_right2"
		left_input = "ui_left2"
		up_input = "ui_up2"
		grab_input = "ui_down2"
		x_left_limit = 0
		x_right_limit = screensize.x / 3
		
	if Input.is_action_pressed(right_input):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
		turning_right()
	elif Input.is_action_pressed(left_input):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
		turning_left()
	else:
		not_turning()
	if Input.is_action_pressed(up_input):
		if !$JetSound.is_playing():
			$JetSound.play()
		velocity.y = max(velocity.y - ACCELERATION, -MAX_SPEED)
		start_emitting_flames()
	else:
		$JetSound.stop()
		stop_emitting_flames()
	
	# Check if block is being carried
	if Input.is_action_just_pressed(grab_input):
		if currently_grabbing:
			$Pickup/PickupCollision.disabled = false
			currently_grabbing = false
			current_grabbed_block.connected_to_drone = false
		elif in_grab_range and !current_grabbed_block.connected_to_drone:
			$PickupSound.play()
			$Pickup/PickupCollision.disabled = true
			currently_grabbing = true
			current_grabbed_block.connected_to_drone = true
		
	if current_grabbed_block != null:
		if currently_grabbing:
			current_grabbed_block.position = Vector2(position.x, position.y + current_grabbed_block.block_offset)
	
	# Calculate drone damage
	if taking_damage:
		health -= 1
	if health <= 0:
		$ShipCollision.disabled = true
		if $DeathTimer.is_stopped():
			$DeathTimer.start()
			$DeathParticles.show()
	
	if position.y >= screensize.y - 70:
		velocity.y = -5
	if position.y <= 0:
		velocity.y = 5
	if position.x >= screensize.x - x_right_limit:
		velocity.x = -5
	if position.x <= 0 + x_left_limit:
		velocity.x = 5
	
	position.x = clamp(position.x, 0 + x_left_limit, screensize.x - x_right_limit)
	position.y = clamp(position.y, 0, screensize.y - 70)
	
	velocity = move_and_slide(velocity, UP)

func _on_Pickup_area_entered(area):
	if !area.get_parent().get_class() == "KinematicBody2D":
		in_grab_range = true
		current_grabbed_block = area.get_parent()

func _on_Pickup_area_exited(area):
	in_grab_range = false
	
func start_emitting_flames():
	if not $FlameLeft.is_emitting() or not $FlameRight.is_emitting() or not$SmokeTrail.is_emitting():
		$FlameLeft.set_emitting(true)
		$FlameRight.set_emitting(true)
		$SmokeTrail.set_emitting(true)

func stop_emitting_flames():
	if $FlameLeft.is_emitting() or $FlameRight.is_emitting():
		$FlameLeft.set_emitting(false)
		$FlameRight.set_emitting(false)
		$SmokeTrail.set_emitting(false)
		
func turning_right():
	if rotation < MAX_ROT:
		rotation += ROT_RATE

func turning_left():
	if rotation > -MAX_ROT:
		rotation -= ROT_RATE
		
func not_turning():
	if abs(rotation) < ROT_RATE:
		rotation = 0
	elif rotation > 0:
		rotation -= ROT_RATE
	else:
		rotation += ROT_RATE
	
func _on_DamageZone_area_entered(area):
	taking_damage = true
	$P1.modulate = Color(100, 100, 100, 100)
	$P2.modulate = Color(100, 100, 100, 100)

func _on_DamageZone_area_exited(area):
	taking_damage = false
	$P1.modulate = Color(1, 1, 1, 1)
	$P2.modulate = Color(1, 1, 1, 1)

func _on_DeathTimer_timeout():
	# position = Vector2(screensize.x / 2, 70)
	set_global_position(Vector2(screensize.x / 2, 70))
	$DeathParticles.hide()
	health = MAX_HEALTH
	$RespawnTimer.start()

func _on_RespawnTimer_timeout():
	$ShipCollision.disabled = false