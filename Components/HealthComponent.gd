extends Node3D
class_name HealthComponent

signal healthChanged
signal defeated

const HP_REGEN_RATE := 2.0  # HP to regen per tick
const HP_REGEN_TIMER := 1.0 # amount of time per tick

@export var max_health: int

var regenerating := false

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

func begin_regen():
	regenerating = true
	while regenerating:
		await get_tree().create_timer(HP_REGEN_TIMER).timeout
		heal(HP_REGEN_RATE)

func stop_regen():
	regenerating = false

# this is just an idea for status effects, still thinking on how to apply multiple
#func begin_ticking_damage(damage_to_tick: int, damage_tick_rate: float, duration: int):
	#while duration > 0:
		#await get_tree().create_timer(damage_tick_rate).timeout
		#take_damage(damage_to_tick)
		#duration -= 1
	
