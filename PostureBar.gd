extends TextureProgressBar

@export var player: Player

func _ready():
	player.postureChanged.connect(update)
	update()
	
func update():
	value = player.posture * 100 / player.max_posture
