extends "res://scenes/BottomBrick.gd"

const CANON_BALL_SCENE = preload("res://scenes/CanonBall.tscn")
var flipped

func _ready():
	._ready()
	if randi() % 2 == 0:
		flipped = true
		$BlockSprite.set_flip_h(true)
	else:
		flipped = false
	
	
func _on_CanonTimer_timeout():
	if !connected_to_drone:
		var rot_offset = 0
		var ball = CANON_BALL_SCENE.instance()
		ball.position = position - Vector2(cos(rotation + rot_offset), sin(rotation + rot_offset)) * 12
		if flipped:
			rot_offset = PI
			ball.position = position + Vector2(cos(rotation + rot_offset), sin(rotation + rot_offset)) * 12
		get_parent().add_child(ball)
		ball.launch(Vector2(cos(rotation), sin(rotation)))