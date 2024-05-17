extends CharacterBody3D
class_name BaseEntity

@export var entity_name: String

var spawn_position: Vector3

func _ready():
	self.spawn_position = global_position
