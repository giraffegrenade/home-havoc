extends RigidBody2D

const LAUNCH_SPEED = 1000

func launch(direction):
	apply_impulse(direction * 10, (direction).normalized() * LAUNCH_SPEED * -1)