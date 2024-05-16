extends Node
class_name HitboxContainer

@export var hitboxes: Array[HitboxComponent] 
var is_empty := false

func _ready() -> void:
	is_empty = hitboxes.size() == 0


