extends State
class_name ClimbState

@export var climb_detection: RayCast3D

var climb_timer: Timer = Timer.new() # how long you can climb for
var climb_cd: Timer = Timer.new()
var climb_speed: float = 1.0
var canClimb := true
var isClimbing := false

func _ready():
	climb_timer.wait_time = 2 # in seconds
	climb_cd.wait_time = 2 # in seconds
	add_child(climb_timer)
	add_child(climb_cd)
	climb_timer.timeout.connect(on_climb_timer_timeout)
	climb_cd.timeout.connect(on_climb_cd_timeout)

func Enter() -> void:
	# if can't climb, jump instead
	if canClimb == false:
		transitioned.emit(self, "JumpState")

func Exit() -> void:
	if not climb_cd.time_left > 0:
		canClimb = false
		climb_cd.start()
	Character.velocity.y = 0
	Character.gravity = 9.8
	isClimbing = false

func Physics_Update(_delta: float) -> void:
	if climb_detection.is_colliding() and canClimb:
#		#play climb animation
		if not isClimbing:
			climb_timer.start()
			isClimbing = true
		while climb_detection.is_colliding() and isClimbing:
			Character.velocity.y = climb_speed
			Character.gravity = 0
			await get_tree().create_timer(0.1).timeout
		climb_timer.stop()
		Character.velocity.y = 0
		Character.gravity = 9.8
		transitioned.emit(self, "JumpState")

func on_climb_timer_timeout():
	climb_timer.stop()
	transitioned.emit(self, "IdleState")

func on_climb_cd_timeout():
	print("Can climb now")
	climb_cd.stop()
	canClimb = true
