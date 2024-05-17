extends Node3D
class_name PostureComponent

signal postureChanged(new_posture: int)

const POSTURE_REGEN_RATE := 2.0  # Posture to regen per tick
const POSTURE_REGEN_TIMER := 1.0 # amount of time per tick

@export var max_posture: int

var regenerating := false


var current_posture: int:
	set(value):
		current_posture = value
		postureChanged.emit(current_posture)
		if current_posture <= 0:
				current_posture = max_posture
				postureChanged.emit(current_posture)
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

func begin_regen():
	regenerating = true
	while regenerating:
		await get_tree().create_timer(POSTURE_REGEN_TIMER).timeout
		heal_posture(POSTURE_REGEN_RATE)

func stop_regen():
	regenerating = false
