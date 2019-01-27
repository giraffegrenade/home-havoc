extends CanvasLayer


func _on_StartButton_pressed():
	#save options
	var config = ConfigFile.new()
	config.set_value("Spawn Rates", "Small Bricks", getRateValue($SpawnRatePanel/SmallBricks.selected))
	config.set_value("Spawn Rates", "Glass", getRateValue($SpawnRatePanel/Glass.selected))
	config.set_value("Spawn Rates", "Large Bricks", getRateValue($SpawnRatePanel/LargeBricks.selected))
	config.set_value("Spawn Rates", "Doors", getRateValue($SpawnRatePanel/Doors.selected))
	config.set_value("Spawn Rates", "Planks", getRateValue($SpawnRatePanel/Planks.selected))
	config.set_value("Spawn Rates", "Turrets", getRateValue($SpawnRatePanel/Turrets.selected))
	config.set_value("Spawn Rates", "Overall", getOverallValue($SpawnRatePanel/Overall.selected))
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
	return -1
	
func getOverallValue(index):
	if index == 0:
		return 30
	if index == 1:
		return 20
	if index == 2:
		return 10
	if index == 3:
		return 5
	if index == 4:
		return 1
	return -1

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
