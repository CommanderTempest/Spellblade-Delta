extends TextureProgressBar

@export var dodge_state: State

func _ready():
	dodge_state.dodgeStateChanged.connect(update)
	update()
	
func update():
	print("Updating dodge icon")
	if dodge_state.canDodge:
		value = 0
	else:
		value = 1