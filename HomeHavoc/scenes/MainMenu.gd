extends CanvasLayer


func _on_PlayButton_pressed():
	get_tree().change_scene("res://scenes/GameSettingsMenu.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func _on_OptionsButton_pressed():
	get_tree().change_scene("res://scenes/OptionsMenu.tscn")


func _on_Tutorial_pressed():
	get_tree().change_scene("res://scenes/Tutorial.tscn")
