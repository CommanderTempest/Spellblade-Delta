extends Node3D
class_name PostureComponent

signal postureChanged

@export var character: CharacterBody3D
@export var max_posture: int

var current_posture: int:
	set(value):
		current_posture = value
		postureChanged.emit()
		if current_posture <= 0:
			if character is Player or character is EnemyController:
				character.state_machine.on_child_transition(character.state_machine.current_state, "StunState")
				current_posture = max_posture
				postureChanged.emit()
		elif current_posture > max_posture:
			current_posture = max_posture
	get:
		return current_posture

func _init(posture: int):
	self.max_posture = posture

func _ready():
	initializePosture()

func initializePosture():
	if max_posture:
		current_posture = max_posture
	else:
		max_posture = 100
		current_posture = max_posture

func setMaxPosture(amount: int):
	max_posture = amount

func hasPostureRemaining() -> bool:
	if current_posture > 0:
		return true
	else: 
		return false

func take_posture_damage(damage: int):
	current_posture -= damage

func heal_posture(amount: int):
	current_posture += amount
