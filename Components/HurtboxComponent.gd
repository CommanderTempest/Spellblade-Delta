extends Area3D
class_name HurtboxComponent

@export var health_component: HealthComponent

func _ready():
	area_entered.connect(areaEntered)

func areaEntered(otherArea: Area3D):
	pass
#	if otherArea is HitboxComponent:
#		if otherArea.getOwner() != self.owner:
#			# instead of taking damage, consider signaling to play or something
#			# to check for parry/block/dodge
#			if otherArea.attack_state.isSwinging:
#				#health_component.take_damage(otherArea.damage_to_deal)
#				print("Hurtbox component has been hit by a hitbox component")

func take_damage(damage: int):
	health_component.take_damage(damage)
