extends "res://scenes/BottomBrick.gd"

const CANON_BALL_SCENE = preload("res://scenes/CanonBall.tscn")

func _on_CanonTimer_timeout():
	var ball = CANON_BALL_SCENE.instance()
	ball.position = position - Vector2(cos(rotation), sin(rotation)) * 12
	get_parent().add_child(ball)
	ball.launch(Vector2(cos(rotation), sin(rotation)))