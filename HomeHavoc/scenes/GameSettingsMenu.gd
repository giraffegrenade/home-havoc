extends CanvasLayer


func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")
	
	#save options
	var config = ConfigFile.new()
	var err = config.load("config")
	if err == OK:
		config.set_value(getRateValue($SpawnRatePanel/SmallBricks.get_selected_id()))
	config.save("config")

func getRateValue(index):
	if index == 0:
		return 0.01
	if index == 1:
		return 0.05
	if index == 2:
		return 0.1
	if index == 3:
		return 0.25
	if index == 4:
		return 0.6

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
