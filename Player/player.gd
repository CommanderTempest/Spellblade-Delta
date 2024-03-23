extends CharacterBody3D

class_name Player

@export var jump_height: float = 1.0
@export var fall_multiplier: float = 2.0
@export var max_hitpoints := 100
@export var max_posture := 100
@export var posture_damage := 20
@export var speed := 2.0

@onready var camera_pivot = $CameraPivot
@onready var smooth_camera = $CameraPivot/SmoothCamera
@onready var animation_player = $AnimationPlayer
@onready var sword = $Arm/Sword
@onready var dodge_timer = $DodgeTimer
@onready var parry_timer = $ParryTimer
@onready var dodge_cd = $DodgeCD
@onready var parry_cd = $ParryCD
@onready var block_cd = $BlockCD
@onready var swing_timer = $Arm/WeaponHandler/SwingTimer # this is attack speed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO

var posture: int = max_posture:
	set(value):
		#update UI
		posture = value
		if posture <= 0:
			print("STUNNED")
			posture = max_posture
var hitpoints: int = max_hitpoints: 
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			print("You're dead lol")

var isDodging := false
var isBlocking := false
var isParrying := false
var isSwinging := false # if the player is swinging/attacking with sword
var canSwing := true    # player can currently attack

var contactEnemy : Node3D # the enemy the weapon is in contact with

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	swing_timer.wait_time = WeaponHandler.get_cd("Sword")
	
func _process(delta) -> void:
	if Input.is_action_just_pressed("dodge") and dodge_cd.is_stopped() and not isBlocking:
		isDodging = true
		dodge_timer.start()
	if Input.is_action_just_pressed("block") and block_cd.is_stopped() and not isDodging:
		isParrying = true
		isBlocking = true
		parry_timer.start()
	if Input.is_action_just_released("block"):
		isParrying = false
		isBlocking = false
		parry_timer.stop()
		block_cd.start()

func _physics_process(delta):
	handle_camera_location()
	# Add the gravity.
	if not is_on_floor():
		# if jumping, apply gravity
		if (velocity.y >= 0):
			velocity.y -= gravity * delta
		# when falling apply more gravity
		else:
			velocity.y -= gravity * delta * fall_multiplier

	if Input.is_action_just_pressed("attack"):
		attack()

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

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

func attack() -> void:
	if canSwing and not isBlocking and not isDodging:
		isSwinging = true
		canSwing = false
		swing_timer.start()
		animation_player.play("Attack")
		if isWeaponInContact and isSwinging:
			print("Hit enemy! Contact")
			if contactEnemy:
				contactEnemy.enemy_take_damage()

func take_damage() -> void:
	if isParrying:
		print("PARRIED!")
	elif isDodging:
		print("DODGED!")
	elif isBlocking:
		print("Blocked, posture took a hit")
		posture -= posture_damage
	else:
		print("YOU'VE BEEN HIT!")
		

#**********TIMERS***********

func _on_dodge_timer_timeout():
	isDodging = false
	print("Dodge on CD")
	dodge_timer.stop()
	dodge_cd.start()
	
func _on_parry_timer_timeout():
	isParrying = false
	print("Parry on CD")
	parry_timer.stop()

func _on_dodge_cd_timeout():
	dodge_cd.stop()
	print("Dodge off CD")

func _on_block_cd_timeout():
	block_cd.stop()
	print("Block off CD")
	
func _on_swing_timer_timeout():
	canSwing = true
	swing_timer.stop()
	
#***********SIGNALS***************

var isWeaponInContact := false # if weapon is currently inside another body

func _on_sword_body_entered(body):
	if body != self:
		if body.is_in_group("Enemy"):
			isWeaponInContact = true
			contactEnemy = body
			print("Hit enemy!")
		elif body.is_in_group("Player"):
			print("Stop hitting yoself")

func _on_sword_body_exited(body):
	if body != self:
		isWeaponInContact = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		isSwinging = false
