extends RigidBody2D

const LAUNCH_SPEED = 100

func launch(direction):
	apply_impulse(direction, direction * 5)