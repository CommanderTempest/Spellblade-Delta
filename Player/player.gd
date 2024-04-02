extends CharacterBody3D

class_name Player

signal healthChanged
signal postureChanged
signal blockStateChanged  # canBlock has changed (used for UI)
signal dodgeStateChanged  # canDodge has changed (used for UI)

@export var max_hitpoints := 100
@export var max_posture := 100
@export var posture_damage := 20
@export var speed := 2.0
@export var player_damage := 20
@export var weapon: Area3D
@export var sparks: PackedScene
@export var blood: PackedScene
@export var state_machine: StateMachine

@onready var camera_pivot = $CameraPivot
@onready var smooth_camera = $CameraPivot/SmoothCamera
@onready var animation_player = $AnimationPlayer
@onready var walk_player = $WalkPlayer
@onready var animation_tree = $AnimationTree
@onready var climb_detection = $ClimbDetection
@onready var climb_timer = $Timers/ClimbTimer
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO

var canClimb := true

var combo := 1

var contactEnemy : Node3D # the enemy the weapon is in contact with

var posture: int = max_posture:
	set(value):
		posture = value
		postureChanged.emit()
		if posture <= 0:
			print("STUNNED")
			posture = max_posture
var hitpoints: int = max_hitpoints: 
	set(value):
		hitpoints = value
		healthChanged.emit()
		if hitpoints <= 0:
			print("You're dead lol")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta) -> void:
	pass
#	if isWeaponInContact and canTickDamage:
#		if contactEnemy:
#			canTickDamage = false
#			contactEnemy.enemy_take_damage(player_damage)

func _physics_process(delta):
	handle_camera_location()
	# Add the gravity.
	

	# Handle Jump.
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#
#		if climb_detection.is_colliding():
#			#play climb animation
#			climb_timer.start()
#			while climb_detection.is_colliding() and canClimb:
#				velocity.y = 0.6
#				self.gravity = 0
#				await get_tree().create_timer(0.1).timeout
#				wait(1)
#			velocity.y = 0
#			self.gravity = 9.8
#		else:
#			velocity.y = sqrt(jump_height * 2.0 * gravity) 
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir.is_zero_approx():
		walk_player.play("Idle")
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		walk_player.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		#playback.stop()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: 
		mouse_motion = -event.relative * 0.001
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func handle_camera_location() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x,
		-90.0,
		90.0
	)
	
	mouse_motion = Vector2.ZERO

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _on_climb_timer_timeout():
	canClimb = false
	climb_timer.stop()
	self.gravity = 9.8
