extends Node

@export var state_machine: StateMachine
@export var dodge_state: DodgeState
@export var block_state: BlockState
@export var attack_state: AttackState
@export var player: CharacterBody3D
@export var walk_player: AnimationPlayer
@export var climb_detection: RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("dodge"):
		if not state_machine.current_state is DodgeState and dodge_state.canDodge:
			state_machine.on_child_transition(state_machine.current_state, "DodgeState")
	elif Input.is_action_pressed("block"):
		if not state_machine.current_state is BlockState and block_state.canBlock:
			state_machine.on_child_transition(state_machine.current_state, "BlockState")
	elif Input.is_action_just_released("block"):
		state_machine.on_child_transition(state_machine.current_state, "IdleState")
	elif Input.is_action_just_pressed("attack"):
		if attack_state.canSwing:
			state_machine.on_child_transition(state_machine.current_state, "AttackState")
		
	if Input.is_action_pressed("dash"):
		player.speed = 3.0
	elif Input.is_action_just_released("dash"):
		player.speed = 2.0
	
func _physics_process(delta):
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		if climb_detection.is_colliding() and not state_machine.current_state is ClimbState:
			state_machine.on_child_transition(state_machine.current_state, "ClimbState")
		else:
			state_machine.on_child_transition(state_machine.current_state, "JumpState")
	elif Input.is_action_just_pressed("jump"):
		if climb_detection.is_colliding() and not state_machine.current_state is ClimbState:
			state_machine.on_child_transition(state_machine.current_state, "ClimbState")
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir.is_zero_approx():
		walk_player.play("Idle")
	if direction:
		player.velocity.x = direction.x * player.speed
		player.velocity.z = direction.z * player.speed
		walk_player.play("Walk")
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
		player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
		#playback.stop()
	player.move_and_slide()



