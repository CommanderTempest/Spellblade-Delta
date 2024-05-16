extends CharacterBody3D
class_name BaseCharacterEntity

@export var entity_name: String
@onready var state_machine = $StateMachine

func get_current_state() -> State:
	return state_machine.current_state

func get_entity_name() -> String:
	return self.entity_name

func set_entity_name(entity_name: String):
	self.entity_name = entity_name
