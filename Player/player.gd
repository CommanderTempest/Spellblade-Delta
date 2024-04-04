extends CharacterBody3D
class_name Player

@export var posture_damage := 20
@export var speed := 2.0
@export var player_damage := 20
@export var state_machine: StateMachine
@export var hurtbox: HurtboxComponent
@export var hitbox: HitboxComponent

@onready var camera_pivot = $CameraPivot
@onready var smooth_camera = $CameraPivot/SmoothCamera
@onready var animation_player = $AnimationPlayer
@onready var walk_player = $WalkPlayer
@onready var animation_tree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hurtbox.hurt.connect(on_hurtbox_hurt)

func _process(delta) -> void:
	pass
#	if isWeaponInContact and canTickDamage:
#		if contactEnemy:
#			canTickDamage = false
#			contactEnemy.enemy_take_damage(player_damage)

func _physics_process(delta):
	handle_camera_location()

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

func getIsSwinging() -> bool:
	if state_machine.current_state is AttackState:
		return state_machine.current_state.isSwinging
	return false

func on_hurtbox_hurt(hurtBy: HitboxComponent):
	# hit by itself
	if hurtBy == hitbox:
		return
	else:
		hurtbox.take_damage(hurtBy.damage_to_deal)
