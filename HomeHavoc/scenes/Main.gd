extends Node

const BOTTOM_BRICK_SCENE = preload("res://scenes/BottomBrick.tscn")

func _on_SpawnTimer_timeout():
	var clone = BOTTOM_BRICK_SCENE.instance()
	add_child(clone)