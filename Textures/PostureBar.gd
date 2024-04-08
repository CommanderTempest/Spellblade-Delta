extends TextureProgressBar

@export var posture_component: PostureComponent

func _ready():
	posture_component.postureChanged.connect(update)
	update()
	
func update():
	value = posture_component.current_posture * 100 / posture_component.max_posture
