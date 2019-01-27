extends Popup

var one_tick_passed = false

func _process(delta):
	if one_tick_passed:
		checkPauseScreen()
	one_tick_passed = true
	
func checkPauseScreen():
	if Input.is_action_just_pressed("ui_pause_screen"):
		get_tree().paused = not get_tree().paused #Toggle pause state
		if get_tree().paused:
			popup_centered_ratio(0.75)
			show()
			one_tick_passed = false
		else:
			hide()


func _on_ResumeButton_pressed():
	get_tree().paused = false #Toggle pause state
	hide()
