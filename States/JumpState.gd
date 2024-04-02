extends State
class_name JumpState

@export var jump_height: float = 1.0
var fall_multiplier := 2.0

var hasHitFloor := false # if the player has hit the floor after jumping

#Possible idea, from here transition to climbing state,
#then when climbing is done, transition to jump so the player goes over a little

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
