extends TextureProgressBar

@export var player: Player

func _ready():
	player.healthChanged.connect(update)
	update()
	
func update():
	value = player.hitpoints * 100 / player.max_hitpoints