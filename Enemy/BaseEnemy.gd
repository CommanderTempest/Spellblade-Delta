extends CharacterBody3D

class_name BaseEnemy

@onready var navigation_agent_3d = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer
@onready var walk_player = $WalkPlayer

@export var max_hitpoints := 100
@export var attack_range := 1.5
@export var enemy_damage := 20
@export var aggro_range := 12.0
@export var attack_speed := 2.0 # How much time passes between attacks
@export var attack_parts: Array[Area3D]
@export var sightLine: Area3D
@export var blood: PackedScene
@export var speed = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var spawnPos: Vector3     # position the enemy spawns at
var isInContact := false  # is the enemy is currently in contact with a target
var primaryTarget: Node3D # the target the enemy is tracking/following
var contactTarget: Node3D # the target the enemy is in contact with
var isAttacking := false  # whether the enemy is currently making an attack
var canAttack := true     # whether the enemy can currently make an attack
var time_between_attacks: Timer = Timer.new()
var moves : Array[String] # holds possible moves for the enemy to attack with
var provoked := false     # whether the enemy is aggroed to a target
var hitpoints: int = max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			defeat()
		elif not provoked:
			provoked = true

#add_child(time_between_attacks)
#*********BUILT-IN FUNCTIONS************

func _ready() -> void:
	spawnPos = self.global_position
	
	# connect every item in attack parts to a contact
	for item in attack_parts:
		print(item.name)
		item.body_entered.connect(entered_contact)
		item.body_exited.connect(exited_contact)

	add_child(time_between_attacks)
	time_between_attacks.wait_time = attack_speed
	time_between_attacks.timeout.connect(attack_timeout)
	
	animation_player.animation_finished.connect(anim_finish)
	
	sightLine.body_entered.connect(detect_target)
	
	get_moves()

func _process(delta) -> void:
	if provoked:
		navigation_agent_3d.target_position = primaryTarget.global_position
	
	if isInContact and isAttacking:
			isAttacking = false # prevent multiple hits registering
			print("Hit Contact!")
			if contactTarget:
				contactTarget.take_damage(enemy_damage)

func _physics_process(delta) ->void:
	var next_position = navigation_agent_3d.get_next_path_position()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = global_position.direction_to(next_position)
	
	if primaryTarget:
		var distance = global_position.distance_to(primaryTarget.global_position)
	
		if (distance < aggro_range):
			provoked = true
		if distance > attack_range:
			self.speed = 2.0
		else:
			self.speed = 1.0
		
		if distance > attack_range * 2:
			print("Disengaging")
			provoked = false
			speed = 1.0
			navigation_agent_3d.target_position = spawnPos
			primaryTarget = null
		
		if provoked:
			if distance <= attack_range:
				attack()
				
	if direction.is_zero_approx() or self.global_position == spawnPos:
		if walk_player.has_animation("Idle"):
			walk_player.play("Idle")
	if direction:
		look_at_target(-direction)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if walk_player.has_animation("Walk"):
			walk_player.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

#**************FUNCTIONS**************

# this function has the enemy face towards the target every frame
func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	# prevents the enemy from tilting when player is on a different elevation
	adjusted_direction.y = 0 
	look_at(global_position + adjusted_direction, Vector3.UP, true)

# this function runs when an enemy is in range of a target
func attack() -> void:
	if canAttack:
		print("or does baseEnemy?")
		if moves.size() > 0:
			var selected_move: String = randomize_move()
			if animation_player.has_animation(selected_move):
				animation_player.play(selected_move)
			else:
				print(self.name + " has no animation: " + selected_move)
		else:
			print(self.name + " no moves found?")

		# can run distance to decide which move to make
		# MOVES SHOULD BE IN THE CHILD CLASSES?
		isAttacking = true
		canAttack = false

func enemy_take_damage(damage: int) -> void:
	print(self.name + " took damage!")
	hitpoints -= damage
	var bleed = blood.instantiate()
	add_child(bleed)
	bleed.global_position = self.global_position

# this function runs when an enemy's HP drops to 0
func defeat() -> void:
	# stop processing attacks
	canAttack = false
	isAttacking = false 
	
	if animation_player.has_animation("Defeat"):
		animation_player.play("Defeat")
	else:
		print(self.name + " has no animation: Defeat")
		queue_free()
	# drop loot?
	# drop exp? hp recovery?
	# start a deathTimer here, when it runs out, run queue_free()

# Based on what's in the animation list, adds possible attacks
func get_moves() -> void:
	if animation_player.has_animation("Attack"):
		moves.append("Attack")
	if animation_player.has_animation("Attack2"):
		moves.append("Attack2")
	if animation_player.has_animation("Attack3"):
		moves.append("Attack3")
	if animation_player.has_animation("Attack4"):
		moves.append("Attack4")

func randomize_move() -> String:
	if moves.size() > 1:
		return moves.pick_random()
	else:
		return "Attack"

func getPrimaryTarget() -> Node3D:
	return primaryTarget

#***************SIGNALS****************

func entered_contact(body):
	if body != self:
		if body.is_in_group("Player") and body is CharacterBody3D:
			contactTarget = body
			isInContact = true

func exited_contact(body):
	isInContact = false

# signal fired when a body enters within the sight range of the enemy
func detect_target(body):
	if body != self:
		if body.is_in_group("Player"):
			primaryTarget = body
			provoked = true

# signal fired when attack timer runs out
func attack_timeout():
	canAttack = true
	print("Stopped attack timeout")
	time_between_attacks.stop()

# signal fired when an animation finishes
func anim_finish(anim_name):
	if (anim_name == "Attack" or anim_name == "Attack2" 
		or anim_name == "Attack3" or anim_name == "Attack4"):
		isAttacking = false
		time_between_attacks.start()
	elif anim_name == "Defeat":
		queue_free()
