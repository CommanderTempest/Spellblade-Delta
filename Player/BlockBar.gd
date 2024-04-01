extends TextureProgressBar

@export var player: Player

func _ready():
	player.blockStateChanged.connect(update)
	update()
	
func update():
	if player.canBlock:
		value = 0
	else:
		value = 1
