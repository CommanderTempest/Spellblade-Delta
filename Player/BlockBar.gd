extends TextureProgressBar

@export var blockState: BlockState

func _ready():
	blockState.blockStateChanged.connect(update)
	update()
	
func update():
	if blockState.canBlock:
		value = 0
	else:
		value = 1
