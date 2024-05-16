extends CharacterBody3D
class_name BaseEntity

@export var entity_name: String

var spawn_position: Vector3

func _ready():
	self.spawn_position = global_position

func get_entity_name() -> String:
	return self.entity_name

func set_entity_name(entity_name: String):
	self.entity_name = entity_name
