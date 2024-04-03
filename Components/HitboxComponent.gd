extends Area3D
class_name HitboxComponent

@export var damage_to_deal: int
@export var attack_state: AttackState
@export var my_hurtbox : HurtboxComponent
var contact_target: HurtboxComponent


func _ready():
	if !damage_to_deal:
		damage_to_deal = 20
	area_entered.connect(areaEntered)
	area_exited.connect(areaExited)

func _process(delta):
	if contact_target and attack_state.isSwinging:
		contact_target.take_damage(damage_to_deal)

func areaEntered(otherArea: Node3D):
	if otherArea is HurtboxComponent:
		print(otherArea.name)
		contact_target = otherArea

func areaExited(otherArea: Node3D) -> void:
	if otherArea is HurtboxComponent and otherArea != my_hurtbox:
		contact_target = null

func getOwner():
	return self.owner
