extends State
class_name JumpState

@export var jump_height: float = 0.4
var fall_multiplier := 2.0

var hasHitFloor := false # if the player has hit the floor after jumping

func Enter() -> void:
	pass

func Exit() -> void:
	hasHitFloor = false

func Physics_Update(_delta: float):
	if not Character.is_on_floor():
		# if jumping, apply gravity
		if (Character.velocity.y >= 0):
			Character.velocity.y -= Character.gravity * _delta
		# when falling apply more gravity
		else:
			Character.velocity.y -= Character.gravity * _delta * fall_multiplier
	else:
		if hasHitFloor:
			transitioned.emit(self, "IdleState")
		else:
			hasHitFloor = true
			Character.velocity.y = sqrt(jump_height * 2.0 * Character.gravity) 
