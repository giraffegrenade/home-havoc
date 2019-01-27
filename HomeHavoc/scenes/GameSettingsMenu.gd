extends CanvasLayer



func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")

