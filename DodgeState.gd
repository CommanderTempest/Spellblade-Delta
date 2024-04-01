extends State
class_name DodgeState

@onready var animation_player = $"../../AnimationPlayer"

var isDodging := false
var canDodge := false

func Enter():
	isDodging = true
	canDodge = false
	
func Exit():
	
