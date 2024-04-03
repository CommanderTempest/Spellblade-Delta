extends State
class_name ClimbState

@export var climb_detection: RayCast3D

var climb_timer: Timer = Timer.new() # how long you can climb for
var canClimb := false

func _ready():
	climb_timer.wait_time = 2 # in seconds
	add_child(climb_timer)
	climb_timer.timeout.connect(on_climb_timer_timeout)

func Enter() -> void:
	canClimb = true

func Exit() -> void:
	pass

func Physics_Update(_delta: float) -> void:
	if climb_detection.is_colliding() and canClimb:
#		#play climb animation
		climb_timer.start()
		while climb_detection.is_colliding() and canClimb:
			Character.velocity.y = 0.6
			Character.gravity = 0
			await get_tree().create_timer(0.1).timeout
		climb_timer.stop()
		Character.velocity.y = 0
		Character.gravity = 9.8
		transitioned.emit(self, "JumpState")

func on_climb_timer_timeout():
	climb_timer.stop()
	canClimb = false
	Character.velocity.y = 0
	Character.gravity = 9.8
	transitioned.emit(self, "IdleState")
