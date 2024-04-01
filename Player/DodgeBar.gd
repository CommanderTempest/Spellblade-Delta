extends TextureProgressBar

@export var player: Player

func _ready():
	player.dodgeStateChanged.connect(update)
	update()
	
func update():
	print("Updating dodge state")
	if player.canDodge:
		value = 0
	else:
		value = 1
