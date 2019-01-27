extends CanvasLayer

func _ready():
	_on_MasterVolumeSlider_value_changed(50) # Start off with 50% volume

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
	
	
func _on_MasterVolumeSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value/100)
	$MasterVolumeSlider/ValueLabel.set_text(str(value/100))

