extends RigidBody2D

var connected_to_drone = true

func _on_Area2D_area_entered(area):
	connected_to_drone = true

func _on_Area2D_area_exited(area):
	connected_to_drone = false
