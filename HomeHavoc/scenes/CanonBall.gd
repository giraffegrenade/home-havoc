extends RigidBody2D

const LAUNCH_SPEED = 1000

func launch(direction):
	apply_impulse(position - direction, (position - direction).normalized() * LAUNCH_SPEED * -1)