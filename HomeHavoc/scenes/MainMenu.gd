extends CanvasLayer


func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Tutorial.tscn")


func _on_Exit_pressed():
	get_tree().quit()
