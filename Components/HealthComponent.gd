extends Node3D
class_name HealthComponent

signal healthChanged
signal defeated

const HP_REGEN_TIME := 2.0

@export var max_health: int
@export var state_machine: StateMachine

var current_health: int:
	set(value):
		current_health = value
		healthChanged.emit()
		if current_health <= 0:
			defeated.emit()
		elif current_health > max_health:
			current_health = max_health

func _ready():
	initializeHealth()
	
func _process(delta):
	pass
	
	# attempt at HP Regen
	#await get_tree().create_timer(HP_REGEN_TIME).timeout
	#heal(5)

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
