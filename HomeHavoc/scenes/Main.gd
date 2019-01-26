extends Node

const SMALL_BRICK_SCENE = preload("res://scenes/BottomBrick.tscn")
const LARGE_BRICK_SCENE = preload("res://scenes/LargeBrick.tscn")

func _on_SpawnTimer_timeout():
	# Choose a random number between 1 and 100
	var randnum = randi()%101+1
	
	var clone
	if randnum < 10:
		clone = LARGE_BRICK_SCENE.instance()
	else:
		clone = SMALL_BRICK_SCENE.instance()
	
	add_child(clone)