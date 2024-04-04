extends Area3D
class_name HurtboxComponent

"""
next idea, put state machine in here, and check the state we're in
and if we're doing/blocking or whatev
"""

signal hurt

@export var health_component: HealthComponent
var canTakeDamage := false

func _ready():
	area_entered.connect(areaEntered)

func areaEntered(otherArea: Area3D):
	if otherArea is HitboxComponent:
		hurt.emit(otherArea as HitboxComponent)

#	if otherArea is HitboxComponent:
#		if otherArea.getOwner() != self.owner:
#			# instead of taking damage, consider signaling to play or something
#			# to check for parry/block/dodge
#			if otherArea.attack_state.isSwinging:
#				#health_component.take_damage(otherArea.damage_to_deal)
#				print("Hurtbox component has been hit by a hitbox component")

func take_damage(damage: int):
	health_component.take_damage(damage)
