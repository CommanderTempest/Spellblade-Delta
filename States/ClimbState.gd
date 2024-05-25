extends State
class_name ClimbState

@export var climb_detection: RayCast3D
@export var head: MeshInstance3D

var climb_timer: Timer = Timer.new() # how long you can climb for
var climb_cd: Timer = Timer.new()
var climb_speed: float = 1.3
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
	else:
		if anim.has_animation("Climb"):
			anim.play("Climb");

func Exit() -> void:
	anim.stop()
	if climb_cd.time_left <= 0:
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
		Character.velocity.y = climb_speed
		Character.gravity = 0
		while climb_detection.is_colliding() and isClimbing:
			await get_tree().create_timer(0.1).timeout
		climb_timer.stop()
		
		#Vaulting
		var u_move_time := 0.2
		var upward_movement = Character.global_transform.origin + (head.basis.y * 0.3)
		var um_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
		um_tween.tween_property(Character, "global_transform:origin", upward_movement, u_move_time)
		
		transitioned.emit(self, "IdleState")

func on_climb_timer_timeout():
	climb_timer.stop()
	transitioned.emit(self, "IdleState")

func on_climb_cd_timeout():
	climb_cd.stop()
	canClimb = true
