extends Area3D
class_name HitboxComponent

var contact_target: CharacterBody3D

func _ready():
	body_entered.connect(bodyEntered)
	body_exited.connect(bodyExited)

func bodyEntered(otherBody: Node3D) -> void:
	if otherBody is CharacterBody3D:
		print("Hit a character: " + str(otherBody.name))
		contact_target = otherBody

func bodyExited(otherBody: Node3D) -> void:
	if otherBody is CharacterBody3D:
		contact_target = null

func getContactTarget() -> CharacterBody3D:
	return contact_target
