extends Node

var list_of_blocks = []
var spawn_blocks = true
var screensize
var bottom_size

const SMALL_BRICK_SCENE = preload("res://scenes/BottomBrick.tscn")
const LARGE_BRICK_SCENE = preload("res://scenes/LargeBrick.tscn")
const LONG_BRICK_SCENE = preload("res://scenes/LongBrick.tscn")
const DOOR_BRICK_SCENE = preload("res://scenes/DoorBrick.tscn")
const WINDOW_BRICK_SCENE = preload("res://scenes/WindowBrick.tscn")
const CANON_BRICK_SCENE = preload("res://scenes/CanonBrick.tscn")

const LINE_SCENE = preload("res://scenes/Line.tscn")

var rates
var spawn_period
var t = 0


func _ready():
	# Start playing music
	$Music.play()
	
	screensize = get_viewport().size
	$Barriers/P2Barrier.position = Vector2(screensize.x / 3, screensize.y / 2)
	$Barriers/P1Barrier.position = Vector2(screensize.x * 2 / 3, screensize.y / 2)
	bottom_size = $Bottom.texture.get_size().y
	
	var config = ConfigFile.new()
	var err = config.load("config.cfg")
	if err == OK: # if not, something went wrong with the file loading
		rates = {
			SmallBricks = config.get_value("Spawn Rates", "SmallBricks", -1),
			Glass = config.get_value("Spawn Rates", "Glass", -1),
			LargeBricks = config.get_value("Spawn Rates", "LargeBricks", -1),
			Doors = config.get_value("Spawn Rates", "Doors", -1),
			Planks = config.get_value("Spawn Rates", "Planks", -1),
			Turrets = config.get_value("Spawn Rates", "Turrets", -1),
		}
		print(rates)
		spawn_period = config.get_value("Spawn Rates", "Overall")
		print(spawn_period)
		$GameTimer.wait_time = int(config.get_value("Game Options", "GameTime"))
		$GameTimer.start()
	else:
		print("Error loading config file")

func _process(delta):
	$TimerLabel.text = str(int($GameTimer.get_time_left()))
	
	$PauseMenu/PauseScreen.checkPauseScreen()

func _on_SpawnTimer_timeout():
	t += 1
	if spawn_blocks and t % spawn_period == 0:
		# Choose a random number between 1 and 100
#		var randnum = float(randi()%101) / 100
		
		var clone
		if float(randi()%101) / 100 < rates["LargeBricks"]:
			clone = LARGE_BRICK_SCENE.instance()
			list_of_blocks.append(clone)
			$BlockHolder.add_child(clone)
		if float(randi()%101) / 100 < rates["Planks"]:
			clone = LONG_BRICK_SCENE.instance()
			list_of_blocks.append(clone)
			$BlockHolder.add_child(clone)
		if float(randi()%101) / 100 < rates["Doors"]:
			clone = DOOR_BRICK_SCENE.instance()
			list_of_blocks.append(clone)
			$BlockHolder.add_child(clone)
		if float(randi()%101) / 100 < rates["Glass"]:
			clone = WINDOW_BRICK_SCENE.instance()
			list_of_blocks.append(clone)
			$BlockHolder.add_child(clone)
		if float(randi()%101) / 100 < rates["SmallBricks"]:
			clone = SMALL_BRICK_SCENE.instance()
			list_of_blocks.append(clone)
			$BlockHolder.add_child(clone)
		if float(randi()%101) / 100 < rates["Turrets"]:
			clone = CANON_BRICK_SCENE.instance()
			list_of_blocks.append(clone)
			$BlockHolder.add_child(clone)
		
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
	var tallest_block_position_P1 = Vector2(0, screensize.y-bottom_size)
	var tallest_block_position_P2 = Vector2(0, screensize.y-bottom_size)
	for block in list_of_blocks:
		var line = LINE_SCENE.instance()
#		add_child(line)
		line.position.x = block.position.x
		line.position.y = getMaxHeightBlock(block)
		if len(block.get_colliding_bodies()) >= 1:
			var player
			block.get_node("BlockSprite").modulate = Color(100,100,100,100) # ///
			if block.position.x > screensize.x * 2 / 3 and getMaxHeightBlock(block) <= tallest_block_position_P1.y:
				tallest_block_position_P1 = block.position
				tallest_block_P1 = block
			elif block.position.x < screensize.x / 3 and getMaxHeightBlock(block) <= tallest_block_position_P2.y:
				tallest_block_position_P2 = block.position
				tallest_block_P2 = block
				
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
		$GameEndLabel.show()
		$GameEndLabel.text = "Draw!"
		
	$ExitGameButton.show()
	$RestartButton.show()
	$TimerLabel.hide()
	display_scores(tallest_block_position_P2.y, tallest_block_position_P1.y)
	
	get_tree().paused = true
	
func actual_score_from_pixels(raw_score):
	return int(ceil((screensize.y - bottom_size) - raw_score))
	
func display_scores(left_score, right_score):
	$Scores/LeftScoreLabel.set_text(str(actual_score_from_pixels(left_score)))
	$Scores/RightScoreLabel.set_text(str(actual_score_from_pixels(right_score)))

func _on_RestartButton_pressed():
	$Music.stop()
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_ExitGameButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/MainMenu.tscn")

