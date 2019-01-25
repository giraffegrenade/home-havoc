extends RigidBody2D

var connected_to_drone = true
var body_on_which_sticked
var tr_ci_collider_to_block = Transform2D()

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	set_use_custom_integrator(false)
	
func _integrate_forces(state):
	if connected_to_drone == false && state.get_contact_count() == 1 :
		connected_to_drone = true
		set_use_custom_integrator(true) 
		body_on_which_sticked = state.get_contact_collider_object(0)
		print("The ball is sticking on a ", body_on_which_sticked.get_name())
		var tr_ci_world_to_ball = get_global_transform()
		var tr_ci_world_to_collider = body_on_which_sticked.get_global_transform()
		tr_ci_collider_to_ball = tr_ci_world_to_collider.inverse() * tr_ci_world_to_ball

func _on_Area2D_area_entered(area):
	connected_to_drone = true

func _on_Area2D_area_exited(area):
	pass # replace with function body
