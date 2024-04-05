extends Node3D
class_name HealthComponent

signal healthChanged

@export var max_health: int
@export var state_machine: StateMachine

var current_health: int:
	set(value):
		current_health = value
		healthChanged.emit()
		if current_health <= 0:
			print(owner.name + " has been felled!")
		elif current_health > max_health:
			current_health = max_health

func _ready():
	initializeHealth()

func initializeHealth():
	if max_health:
		current_health = max_health
	else:
		max_health = 100
		current_health = max_health

func setMaxHealth(amount: int):
	max_health = amount

func hasHealthRemaining() -> bool:
	if current_health > 0:
		return true
	else: 
		return false

func take_damage(damage: int):
	current_health -= damage

func heal(amount: int):
	current_health += amount
