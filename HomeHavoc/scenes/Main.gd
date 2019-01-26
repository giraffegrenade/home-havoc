extends Node

var list_of_blocks = []
var spawn_blocks = true
var screensize

const SMALL_BRICK_SCENE = preload("res://scenes/BottomBrick.tscn")
const LARGE_BRICK_SCENE = preload("res://scenes/LargeBrick.tscn")
const LONG_BRICK_SCENE = preload("res://scenes/LongBrick.tscn")

func _ready():
	screensize = get_viewport().size
	$Barriers/P2Barrier.position = Vector2(screensize.x / 3, screensize.y / 2)
	$Barriers/P1Barrier.position = Vector2(screensize.x * 2 / 3, screensize.y / 2)

func _process(delta):
	$TimerLabel.text = str(int($GameTimer.get_time_left()))

func _on_SpawnTimer_timeout():
	if spawn_blocks:
		# Choose a random number between 1 and 100
		var randnum = randi()%101+1
		
		var clone
		if randnum < 10:
			clone = LARGE_BRICK_SCENE.instance()
		elif randnum < 40:
			clone = LONG_BRICK_SCENE.instance()
		else:
			clone = SMALL_BRICK_SCENE.instance()
		
		list_of_blocks.append(clone)
		add_child(clone)

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
		if len(block.get_colliding_bodies()) >= 1:
			var player
			block.get_node("BlockSprite").modulate = Color(100,100,100,100) # ///
			if block.position.x > screensize.x * 2 / 3 and block.position.y <= tallest_block_position_P1.y:
				tallest_block_position_P1 = block.position
				tallest_block_P1 = block
			elif block.position.x < screensize.x / 3 and block.position.y <= tallest_block_position_P2.y:
				tallest_block_position_P2 = block.position
				tallest_block_P2 = block
	
	$Arrow/GameEndLabel.show()
	if tallest_block_position_P1.y < tallest_block_position_P2.y and tallest_block_P1 != null:
		tallest_block_P1.get_node("BlockSprite").modulate = Color(10,0,0,10)
		$Arrow.show()
		$Arrow.set_flip_h(true)
		$Arrow/GameEndLabel.text = "Winner!"
		show_confetti()
	elif tallest_block_position_P2.y < tallest_block_position_P1.y and tallest_block_P2 != null:
		tallest_block_P2.get_node("BlockSprite").modulate = Color(10,0,0,10)
		$Arrow.show()
		$Arrow.set_flip_h(false)
		$Arrow/GameEndLabel.text = "Winner!"
		show_confetti()
	else:
		$Arrow/GameEndLabel.text = "Draw!"
		
	$ExitGameButton.show()
	$RestartButton.show()

func show_confetti():
	$ConfettiHolder/Confetti.show()
	$ConfettiHolder/Confetti2.show()

func _on_RestartButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_ExitGameButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")