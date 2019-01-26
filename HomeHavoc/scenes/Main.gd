extends Node

var list_of_blocks = []
var spawn_blocks = true
var screensize

const SMALL_BRICK_SCENE = preload("res://scenes/BottomBrick.tscn")
const LARGE_BRICK_SCENE = preload("res://scenes/LargeBrick.tscn")

func _ready():
	screensize = get_viewport().size

func _on_SpawnTimer_timeout():
	if spawn_blocks:
		# Choose a random number between 1 and 100
		var randnum = randi()%101+1
		
		var clone
		if randnum < 10:
			clone = LARGE_BRICK_SCENE.instance()
		else:
			clone = SMALL_BRICK_SCENE.instance()
		
		list_of_blocks.append(clone)
		add_child(clone)

func _on_GameTimer_timeout():
	for block in list_of_blocks:
		# Set block mode to MODE_STATIC
		block.set_mode(1)
		
		spawn_blocks = false
	
	var tallest_block
	var tallest_block_position = Vector2(0, screensize.y)
	for block in list_of_blocks:
		if len(block.get_colliding_bodies()) >= 1:
			block.get_node("BlockSprite").modulate = Color(10,10,10,10) # ///
			if block.position.y <= tallest_block_position.y:
				tallest_block_position = block.position
				tallest_block = block
				
	tallest_block.get_node("BlockSprite").modulate = Color(10,0,0,10)
	
	if tallest_block_position.x > screensize * 2 / 3:
		print("RIGHT PLAYER WINS")