extends Node
class_name PlayerController

@export var player_entity: PlayerEntity

func _input(event) -> void:
	if player_entity.can_make_action():
		if event == Input.is_action_just_pressed("dodge"):
			player_entity.transition_state("DodgeState")
		elif event == Input.is_action_just_pressed("block"):
			player_entity.transition_state("BlockState")
		elif event == Input.is_action_just_released("block"):
			player_entity.transition_state("IdleState")
		elif event == Input.is_action_just_pressed("attack"):
			if player_entity.can_make_attack():
				player_entity.transition_state("AttackState")
				
		if event == Input.is_action_pressed("dash"):
			player_entity.speed = 3.0
		elif event == Input.is_action_just_released("dash"):
			player_entity.speed = 2.0
		
		if event == Input.is_action_just_pressed("jump"):
			if player_entity.climb_detector.is_colliding():
				player_entity.transition_state("ClimbState")
			elif player_entity.is_on_floor():
				player_entity.transition_state("JumpState")

func _physics_process(delta) -> void:
	if self.player_entity.can_make_action():
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction = (player_entity.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if input_dir.is_zero_approx():
			#walk_player.play("Idle")
			pass
		if direction:
			player_entity.velocity.x = direction.x * player_entity.speed
			player_entity.velocity.z = direction.z * player_entity.speed
			#walk_player.play("Walk")
		else:
			player_entity.velocity.x = move_toward(player_entity.velocity.x, 0, player_entity.speed)
			player_entity.velocity.z = move_toward(player_entity.velocity.z, 0, player_entity.speed)
			#playback.stop()
		player_entity.move_and_slide()


# @deprecated
# Old PlayerController below


#@export var state_machine: StateMachine
#@export var dodge_state: DodgeState
#@export var block_state: BlockState
#@export var attack_state: AttackState
#@export var stun_state: StunState
#@export var player: CharacterBody3D
#@export var walk_player: AnimationPlayer
#@export var climb_detection: RayCast3D
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if not stun_state.is_stunned:
		#if Input.is_action_just_pressed("dodge"):
			#if not state_machine.current_state is DodgeState and dodge_state.canDodge:
				#state_machine.on_child_transition(state_machine.current_state, "DodgeState")
		#elif Input.is_action_pressed("block"):
			#if not state_machine.current_state is BlockState and block_state.canBlock:
				#state_machine.on_child_transition(state_machine.current_state, "BlockState")
		#elif Input.is_action_just_released("block"):
			#state_machine.on_child_transition(state_machine.current_state, "IdleState")
		#elif Input.is_action_just_pressed("attack"):
			#if attack_state.canSwing:
				#state_machine.on_child_transition(state_machine.current_state, "AttackState")
			#
		#if Input.is_action_pressed("dash"):
			#player.speed = 3.0
		#elif Input.is_action_just_released("dash"):
			#player.speed = 2.0
	#
