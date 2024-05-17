extends Node
class_name HitboxContainer

@export var hitboxes: Array[HitboxComponent] 
var is_empty := false

func _ready() -> void:
	is_empty = hitboxes.size() == 0

func is_in_container(hitbox: HitboxComponent) -> bool:
	if hitboxes.find(hitbox):
		return true
	else:
		return false


