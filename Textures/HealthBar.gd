extends TextureProgressBar

@export var health_component: HealthComponent

func _ready():
	health_component.healthChanged.connect(update)
	update()
	
func update():
	value = health_component.current_health * 100 / health_component.max_health
