extends Area3D
class_name HitboxComponent

@export var damage_to_deal: int = 16
@export var attack_state: AttackState
@export var my_hurtbox : HurtboxComponent

var contact_target: HurtboxComponent
var canTickDamage := true
var rng = RandomNumberGenerator.new()

func _ready():
	if !damage_to_deal:
		damage_to_deal = 20
	area_entered.connect(areaEntered)
	area_exited.connect(areaExited)

func _process(delta):
	if contact_target and attack_state.isSwinging:
		if canTickDamage:
			canTickDamage = false
			deal_random_damage(contact_target)

func setTickDamage(canTick: bool) -> void:
	canTickDamage = canTick

func areaEntered(otherArea: Node3D):
	if otherArea is HurtboxComponent and otherArea != my_hurtbox:
		contact_target = otherArea
		if canTickDamage:
			canTickDamage = false
			deal_random_damage(otherArea)

func areaExited(otherArea: Node3D) -> void:
	if otherArea is HurtboxComponent and otherArea != my_hurtbox:
		contact_target = null
		
func deal_random_damage(otherArea: HurtboxComponent):
	var random_damage = round(rng.randf_range(damage_to_deal-4, damage_to_deal+4))
	otherArea.take_damage(random_damage)

func getOwner():
	return self.owner
