extends Area3D
class_name HurtboxComponent

"""
next idea, put state machine in here, and check the state we're in
and if we're doing/blocking or whatev
"""

signal hurt

@export var health_component: HealthComponent
@export var posture_component: PostureComponent
@export var character: CharacterBody3D
@export var blood: PackedScene # don't know if I should use particles here
@export var sparks: PackedScene
var canTakeDamage := false

func _ready():
	area_entered.connect(areaEntered)

func areaEntered(otherArea: Area3D):
	if otherArea is HitboxComponent:
		#hurt.emit(otherArea as HitboxComponent)
		pass

#	if otherArea is HitboxComponent:
#		if otherArea.getOwner() != self.owner:
#			# instead of taking damage, consider signaling to play or something
#			# to check for parry/block/dodge
#			if otherArea.attack_state.isSwinging:
#				#health_component.take_damage(otherArea.damage_to_deal)
#				print("Hurtbox component has been hit by a hitbox component")

func take_damage(damage: int):
	var status: String
	if character is Player or character is EnemyController:
		status = character.getStatus()
		if status == "Parry":
			var spark = sparks.instantiate()
			add_child(spark)
			spark.global_position = self.global_position
			if posture_component:
				posture_component.heal_posture(damage)
		elif status == "Block" and posture_component.hasPostureRemaining():
			var spark = sparks.instantiate()
			add_child(spark)
			spark.global_position = self.global_position
			if posture_component:
				posture_component.take_posture_damage(damage)
		elif status == "Dodge":
			#Dodge
			print("DODGED!")
		else:
			var bleed = blood.instantiate()
			add_child(bleed)
			bleed.global_position = self.global_position
			health_component.take_damage(damage)
