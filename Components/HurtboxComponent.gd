extends Area3D
class_name HurtboxComponent

@export var health_component: HealthComponent

func _ready():
	area_entered.connect(areaEntered)

func areaEntered(otherArea: Area3D):
	if otherArea is HitboxComponent:
		print("Hurtbox component has been hit by a hitbox component")
