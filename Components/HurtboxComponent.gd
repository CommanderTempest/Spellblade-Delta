extends Area3D
class_name HurtboxComponent

signal trigger_hit(otherArea: HitboxComponent)

const COMBAT_TIMEOUT := 10 # number of seconds until out of combat after being damaged

@export var health_component: HealthComponent
@export var posture_component: PostureComponent
@export var character: CharacterBody3D
@export var blood: PackedScene # don't know if I should use particles here
@export var sparks: PackedScene
@export var ParrySound: AudioStreamPlayer3D

var canTakeDamage := false

var combat_timer: Timer = Timer.new()
var in_combat := false

func _ready():
	combat_timer.wait_time = COMBAT_TIMEOUT
	add_child(combat_timer)
	combat_timer.timeout.connect(on_combat_timeout)
	area_entered.connect(areaEntered)

func _process(delta):
	if not in_combat:
		health_component.heal(1)
		posture_component.heal_posture(1)

func areaEntered(otherArea: Area3D):
	if otherArea is HitboxComponent:
		#hurt.emit(otherArea as HitboxComponent)
		pass

# returns DEF value
func get_defense() -> int:
	
	# overall this is a bad way to do it, due to checking all armors
	# everytime we get hit, but it's currently easier to do it this way
	# until reworks happen
	
	if character is Player:
		return character.get_armor()
	return 0

func take_damage(damage: int):
	combat_timer.start()
	in_combat = true
	var status: String
	if character is Player or character is EnemyController:
		status = character.getStatus()
		if status == "Parry":
			ParrySound.play()
			var spark = sparks.instantiate()
			add_child(spark)
			spark.global_position = character.global_position
			if posture_component:
				posture_component.heal_posture(damage)
		elif status == "Block" and posture_component.hasPostureRemaining():
			ParrySound.play()
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
			
			var damage_to_take = damage - get_defense()
			if damage_to_take <= 0:
				damage_to_take = 1
			print("Will take " + str(damage_to_take))
			health_component.take_damage(damage_to_take)

func on_combat_timeout():
	combat_timer.stop()
	in_combat = false
