extends Node

var list_of_blocks = []
var spawn_blocks = true
var screensize

const SMALL_BRICK_SCENE = preload("res://scenes/BottomBrick.tscn")
const LARGE_BRICK_SCENE = preload("res://scenes/LargeBrick.tscn")
const LONG_BRICK_SCENE = preload("res://scenes/LongBrick.tscn")
const DOOR_BRICK_SCENE = preload("res://scenes/DoorBrick.tscn")
const WINDOW_BRICK_SCENE = preload("res://scenes/WindowBrick.tscn")

func _ready():
	screensize = get_viewport().size
	$Barriers/P2Barrier.position = Vector2(screensize.x / 3, screensize.y / 2)
	$Barriers/P1Barrier.position = Vector2(screensize.x * 2 / 3, screensize.y / 2)

func _process(delta):
	$TimerLabel.text = str(int($GameTimer.get_time_left()))
	
	if Input.is_action_just_pressed("ui_pause_screen"):
		pass

func _on_SpawnTimer_timeout():
	if spawn_blocks:
		# Choose a random number between 1 and 100
		var randnum = randi()%101+1
		
		var clone
		if randnum < 10:
			clone = LARGE_BRICK_SCENE.instance()
		elif randnum < 20:
			clone = LONG_BRICK_SCENE.instance()
		elif randnum < 40:
			clone = DOOR_BRICK_SCENE.instance()
		elif randnum < 60:
			clone = WINDOW_BRICK_SCENE.instance()
		else:
			clone = SMALL_BRICK_SCENE.instance()
		
		list_of_blocks.append(clone)
		add_child(clone)
		
func getMaxHeightBlock(block):
	#Gets the top of the block, including rotation
	var hypot = pow(pow(block.dimensions.x, 2) + pow(block.dimensions.y, 2), 0.5) / 2
	var main_angle = block.rotation
	var diff_angle = atan(block.dimensions.y/block.dimensions.x)
	return block.position.y - hypot * max(abs(sin(main_angle-diff_angle)), abs(sin(main_angle+diff_angle)))

func _on_GameTimer_timeout():
	for block in list_of_blocks:
		# Set block mode to MODE_STATIC
		block.set_mode(1)
		spawn_blocks = false
	var tallest_block_P1
	var tallest_block_P2
	var tallest_block_position_P1 = Vector2(0, screensize.y)
	var tallest_block_position_P2 = Vector2(0, screensize.y)
	for block in list_of_blocks:
		print(block.rotation)
		if len(block.get_colliding_bodies()) >= 1:
			var player
			block.get_node("BlockSprite").modulate = Color(100,100,100,100) # ///
			if block.position.x > screensize.x * 2 / 3 and getMaxHeightBlock(block) <= tallest_block_position_P1.y:
				tallest_block_position_P1 = block.position
				tallest_block_P1 = block
			elif block.position.x < screensize.x / 3 and getMaxHeightBlock(block) <= tallest_block_position_P2.y:
				tallest_block_position_P2 = block.position
				tallest_block_P2 = block
	
	$GameEndLabel.show()
	if tallest_block_position_P1.y < tallest_block_position_P2.y and tallest_block_P1 != null:
		tallest_block_P1.get_node("BlockSprite").modulate = Color(10,0,0,10)
		$ConfettiHolder/Confetti2.show()
		$Line.position.x = tallest_block_position_P1.x
		$Line.position.y = getMaxHeightBlock(tallest_block_P1)
	elif tallest_block_position_P2.y < tallest_block_position_P1.y and tallest_block_P2 != null:
		tallest_block_P2.get_node("BlockSprite").modulate = Color(10,0,0,10)
		$ConfettiHolder/Confetti.show()
		$Line.position.x = tallest_block_position_P2.x
		$Line.position.y = getMaxHeightBlock(tallest_block_P2)
	else:
		$GameEndLabel.text = "Draw!"
		
	$ExitGameButton.show()
	$RestartButton.show()

func _on_RestartButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_ExitGameButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")