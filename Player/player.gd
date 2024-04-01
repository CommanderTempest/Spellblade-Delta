extends CharacterBody3D

class_name Player

signal healthChanged
signal postureChanged
signal blockStateChanged  # canBlock has changed (used for UI)
signal dodgeStateChanged  # canDodge has changed (used for UI)

@export var jump_height: float = 1.0
@export var fall_multiplier: float = 2.0
@export var max_hitpoints := 100
@export var max_posture := 100
@export var posture_damage := 20
@export var speed := 2.0
@export var player_damage := 20
@export var weapon: Area3D
@export var sparks: PackedScene
@export var blood: PackedScene

@onready var camera_pivot = $CameraPivot
@onready var smooth_camera = $CameraPivot/SmoothCamera
@onready var animation_player = $AnimationPlayer
@onready var walk_player = $WalkPlayer
@onready var animation_tree = $AnimationTree
@onready var dodge_cd = $Timers/Dodge_CD
@onready var block_cd = $Timers/Block_CD
@onready var swing_cd = $Timers/Swing_CD
@onready var combo_timer = $Timers/ComboTimer
@onready var parry_timer = $Timers/ParryTimer
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var mouse_motion := Vector2.ZERO

var isBlocking := false
var isParrying := false
var isDodging := false
var isSwinging := false

var canBlock := true:
	set(value):
		canBlock = value
		blockStateChanged.emit() 
var canDodge := true:
	set(value):
		canDodge = value
		dodgeStateChanged.emit()
var canSwing := true
var canTickDamage := true

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
	
	weapon.body_entered.connect(_on_weapon_body_entered)
	weapon.body_exited.connect(_on_weapon_body_exited)

func _process(delta) -> void:
	if Input.is_action_just_pressed("dodge") and canDodge and not isBlocking and not isSwinging:
		dodge()
	elif Input.is_action_pressed("block") and canBlock and not isDodging and not isSwinging:
		block()
	elif Input.is_action_just_pressed("attack") and canSwing and not isBlocking and not isDodging:
		attack()
	if Input.is_action_just_released("block") and isBlocking:
		canBlock = false
		block_cd.start()
		animation_player.queue("Idling")
		isBlocking = false
		
	if Input.is_action_pressed("dash"):
		speed = 3.0
	elif Input.is_action_just_released("dash"):
		speed = 2.0
		
	if isWeaponInContact and canTickDamage:
		if contactEnemy:
			canTickDamage = false
			contactEnemy.enemy_take_damage(player_damage)

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

func dodge() -> void:
	if animation_player.has_animation("Dodge"):
		isDodging = true
		canDodge = false
		animation_player.play("Dodge")
		dodge_cd.start()

func block() -> void:
	if not isBlocking:
		canBlock = false
		isParrying = true
		parry_timer.start()
		isBlocking = true
		animation_player.play("Parry")
		animation_player.queue("HoldBlock")

func attack() -> void:
	if animation_player.has_animation("Attack" + str(combo)):
		canSwing = false
		isSwinging = true 
		canTickDamage = true
		animation_player.play("Attack" + str(combo))
	combo += 1
	
func take_damage(damage: int) -> void:
	if isParrying:
		print("PARRIED!")
		posture += 40
		var spark: GPUParticles3D = sparks.instantiate()
		spark.amount = 20
		add_child(spark)
		spark.global_position = weapon.global_position
	elif isDodging:
		print("DODGED!")
		#particle for successful dodge
	elif isBlocking:
		posture -= posture_damage
		
		var spark = sparks.instantiate()
		add_child(spark)
		spark.global_position = weapon.global_position
	else:
		hitpoints -= damage
		var bleed = blood.instantiate()
		add_child(bleed)
		bleed.global_position = self.global_position
		bleed.global_position.y += 0.1

func getIsSwinging() -> bool:
	return self.isSwinging

#******************SIGNALS*****************
var isWeaponInContact := false # if weapon is currently inside another body

func _on_weapon_body_entered(body):
	if body != self and body.is_in_group("Enemy"):
		isWeaponInContact = true
		contactEnemy = body

func _on_weapon_body_exited(body):
	if body != self:
		isWeaponInContact = false
		contactEnemy = null

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Dodge":
		isDodging = false
	elif anim_name == "Parry":
		isParrying = false
	elif anim_name == "Attack1" or anim_name == "Attack2" or anim_name == "Attack3":
		isSwinging = false
		canSwing = true
		combo_timer.start()
	if anim_name == "Attack3":
		# this if statement should be the last attack animation in the combo
		combo = 1
		combo_timer.stop()

#***************TIMER SIGNALS****************

func _on_dodge_cd_timeout():
	canDodge = true
	dodge_cd.stop()

func _on_block_cd_timeout():
	print("Blcok timeout")
	canBlock = true
	block_cd.stop()

func _on_combo_timer_timeout():
	combo_timer.stop()
	combo = 1
	canSwing = true
	isSwinging = false
	print("Running an idle")
	animation_player.stop()
	animation_player.play("Idling")

func _on_parry_timer_timeout():
	isParrying = false
	parry_timer.stop()
