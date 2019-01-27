extends "res://scenes/BottomBrick.gd"

const CANON_BALL_SCENE = preload("res://scenes/CanonBrick.tscn")

func _on_CanonTimer_timeout():
	var ball = CANON_BALL_SCENE.scene.instance()
	ball.position = position
	add_child(ball)
	ball.launch(Vector2(position.x - 10, position.y))