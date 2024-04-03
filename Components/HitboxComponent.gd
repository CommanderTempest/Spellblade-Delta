extends Area3D
class_name HitboxComponent

@export var damage_to_deal: int

var contact_target: CharacterBody3D

func _ready():
	if !damage_to_deal:
		damage_to_deal = 20
	body_entered.connect(bodyEntered)
	body_exited.connect(bodyExited)

func bodyEntered(otherBody: Node3D) -> void:
	if otherBody != owner and otherBody is CharacterBody3D:
		print("Hit a character: " + str(otherBody.name))
		contact_target = otherBody

func bodyExited(otherBody: Node3D) -> void:
	if otherBody is CharacterBody3D:
		contact_target = null

func getOwner():
	return self.owner

func getContactTarget() -> CharacterBody3D:
	return contact_target
