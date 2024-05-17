extends Area3D
class_name HitboxComponent

@export var min_damage_to_deal: int = 12
@export var max_damage_to_deal: int = 20
var hitbox_owner: CharacterEntity = self.owner

var contact_target: HurtboxComponent
var rng = RandomNumberGenerator.new()

func _ready():
	area_entered.connect(areaEntered)
	area_exited.connect(areaExited)

func _process(delta):
	pass

func areaEntered(otherArea: Node3D):
	if otherArea is HurtboxComponent and otherArea != hitbox_owner.get_hurtbox():
		contact_target = otherArea

func areaExited(otherArea: Node3D) -> void:
	if otherArea is HurtboxComponent and otherArea != hitbox_owner.get_hurtbox():
		contact_target = null

func getOwner():
	return self.hitbox_owner

func get_contact_target() -> HurtboxComponent:
	return self.contact_target

func get_random_damage_to_deal() -> int:
	var random_damage = round(rng.randf_range(min_damage_to_deal, max_damage_to_deal))
	return random_damage
