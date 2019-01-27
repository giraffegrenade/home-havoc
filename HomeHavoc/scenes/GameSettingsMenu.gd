extends CanvasLayer


func _on_StartButton_pressed():
	#save options
	var config = ConfigFile.new()
	config.set_value("Spawn Rates", "Small Bricks", getRateValue($SpawnRatePanel/SmallBricks.get_selected_id()))
	config.set_value("Spawn Rates", "Glass", getRateValue($SpawnRatePanel/Glass.get_selected_id()))
	config.set_value("Spawn Rates", "Large Bricks", getRateValue($SpawnRatePanel/LargeBricks.get_selected_id()))
	config.set_value("Spawn Rates", "Doors", getRateValue($SpawnRatePanel/Doors.get_selected_id()))
	config.set_value("Spawn Rates", "Planks", getRateValue($SpawnRatePanel/Planks.get_selected_id()))
	config.set_value("Spawn Rates", "Turrets", getRateValue($SpawnRatePanel/Turrets.get_selected_id()))
	config.save("config.cfg")
	
	get_tree().change_scene("res://scenes/Main.tscn")

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
