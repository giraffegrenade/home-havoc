extends Panel

func add_rate_options(option_button):
	option_button.add_item("Very Rare")
	option_button.add_item("Rare")
	option_button.add_item("Common")
	option_button.add_item("Very Common")
	option_button.add_item("Insanely Common")

func _ready():
	add_rate_options($SmallBricks)
	add_rate_options($Glass)
	add_rate_options($LargeBricks)
	add_rate_options($Doors)
	add_rate_options($Planks)
	add_rate_options($Turrets)
	
	$SmallBricks.select(3)
	$Glass.select(2)
	$LargeBricks.select(1)
	$Doors.select(1)
	$Planks.select(2)
	$Turrets.select(0)