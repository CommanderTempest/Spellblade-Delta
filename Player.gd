extends CharacterBody3D

class_name Player

@export var jump_height: float = 1.0
@export var fall_multiplier: float = 2.0
@export var max_hitpoints := 100
@export var max_posture := 100
@export var posture_damage := 20
@export var speed := 2.0
@export var player_damage := 20
@export var weapon: Area3D

@onready var camera_pivot = $CameraPivot
@onready var smooth_camera = $CameraPivot/SmoothCamera
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var dodge_cd = $Timers/Dodge_CD
@onready var block_cd = $Timers/Block_CD
@onready var swing_cd = $Timers/Swing_CD
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO

var isBlocking := false
var isParrying := false
var isDodging := false
var isSwinging := false

var canBlock := true 
var canDodge := true
var canSwing := true

var contactEnemy : Node3D # the enemy the weapon is in contact with

var posture: int = max_posture:
	set(value):
		#update UI
		posture = value
		if posture <= 0:
			print("STUNNED")
			posture = max_posture
var hitpoints: int = max_hitpoints: 
	set(value):
		#update UI
		hitpoints = value
		if hitpoints <= 0:
			print("You're dead lol")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	weapon.body_entered.connect(_on_weapon_body_entered)
	weapon.body_exited.connect(_on_weapon_body_exited)
	
	

func _process(delta) -> void:
	if Input.is_action_just_pressed("dodge") and canDodge and not isBlocking:
		isDodging = true
		canDodge = false
		if animation_player.has_animation("Dodge"):
			playback.travel("Dodge")
		dodge_cd.start()
	if Input.is_action_just_pressed("block") and canBlock and not isDodging:
		isParrying = true
		#probably need a timer to determine how long a parry lasts
	if Input.is_action_just_released("block"):
		isParrying = false
		isBlocking = false
		block_cd.start()
	if Input.is_action_pressed("block") and block_cd.is_stopped() and not isDodging:
		isBlocking = true

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
		playback.travel("Walk")
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

func attack() -> void:
	if canSwing and not isBlocking and not isDodging:
		canSwing = false
		isSwinging = true 
		if animation_player.has_animation("Attack1"):
			animation_player.play("Attack1")
		if isWeaponInContact:
			print("Hit enemy! Contact")
			if contactEnemy:
				contactEnemy.enemy_take_damage(player_damage)

func take_damage(damage: int) -> void:
	if isParrying:
		print("PARRIED!")
		posture += 40
		#particle for successful parry
	elif isDodging:
		print("DODGED!")
		#particle for successful dodge
	elif isBlocking:
		print("Blocked, posture took a hit")
		posture -= posture_damage
		#smaller parry particle
	else:
		print("YOU'VE BEEN HIT!")
		hitpoints -= damage
		#particles for damage (red)

func getIsSwinging() -> bool:
	return self.isSwinging

#******************SIGNALS*****************
var isWeaponInContact := false # if weapon is currently inside another body

func _on_weapon_body_entered(body):
	if body != self and body is CharacterBody3D:
		isWeaponInContact = true
		contactEnemy = body

func _on_weapon_body_exited(body):
	if body != self:
		isWeaponInContact = false

#***************TIMER SIGNALS****************

func _on_dodge_cd_timeout():
	canDodge = true
	dodge_cd.stop()

func _on_block_cd_timeout():
	canBlock = true
	block_cd.stop()

func _on_swing_cd_timeout():
	canSwing = true
	swing_cd.stop()
	# maybe refactor this to: if left clicked again, wait for anim to finish
	# then combo into second move

# @deprecated
# ceases operations on the animation player
func _on_animation_player_animation_finished(anim_name):
	# player is no longer dodging
	if anim_name == "Dodge":
		isDodging = false
		print("Dodging finished?")
	elif anim_name == "Block":
		isBlocking = false
		isParrying = false

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "Dodge":
		isDodging = false
	elif anim_name == "Block":
		isBlocking = false
		isParrying = false
