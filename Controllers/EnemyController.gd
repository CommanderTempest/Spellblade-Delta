extends CharacterBody3D
class_name EnemyController

signal AttackingEntity # signals to the mob group component that a target's been registered

@export var state_machine: StateMachine
@export var sightLine: Area3D
@export var navigation: PathfindComponent
@export var attack_range = 0.5
@export var hurtbox: HurtboxComponent
@export var hitbox: HitboxComponent
@export var healthComp: HealthComponent
@export var climb_detection: RayCast3D
@export var stun_state: StunState

@onready var animation_player = $AnimationPlayer

var primary_target: PlayerEntity

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var rng = RandomNumberGenerator.new()
var spawn_pos: Vector3 
var provoked := false
var is_dying := false

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_pos = global_position
	sightLine.body_entered.connect(on_sight_entered)
	hurtbox.hurt.connect(on_hurtbox_hurt)
	healthComp.defeated.connect(on_defeat)
	animation_player.animation_finished.connect(on_anim_finish)
	animation_player.animation_changed.connect(on_anim_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if not stun_state.is_stunned and not is_dying:
		if navigation.tracking_target:
			# sets speed of enemy depending on how far they are
			navigation.check_range(attack_range) 

			if navigation.get_distance_to_target() > attack_range * 50:
				navigation.return_to_spawn()
				state_machine.on_child_transition(state_machine.current_state, "IdleState")

			if provoked:
				if navigation.get_distance_to_target() <= attack_range:
					if primary_target.getIsSwinging():
						var randomizedState: String = randomize_move()
						if randomize_move() != "None":
							state_machine.on_child_transition(state_machine.current_state, randomizedState)
					else:
						if state_machine.current_state is AttackState:
							if !state_machine.current_state.isSwinging:
								state_machine.on_child_transition(state_machine.current_state, "AttackState")
						else:
							state_machine.on_child_transition(state_machine.current_state, "AttackState")
				elif primary_target:
					# 1.0 is jump height here
					if primary_target.global_position.y - 1.0 >= self.global_position.y:
						if climb_detection.is_colliding() and not state_machine.current_state is ClimbState:
							state_machine.on_child_transition(state_machine.current_state, "ClimbState")
					elif primary_target.global_position.y >= self.global_position.y:
						state_machine.on_child_transition(state_machine.current_state, "JumpState")
				else:
					state_machine.on_child_transition(state_machine.current_state, "IdleState")

func getStatus() -> String:
	if state_machine.current_state is BlockState:
		if state_machine.current_state.isParrying:
			return "Parry"
		elif state_machine.current_state.isBlocking:
			return "Block"
	elif state_machine.current_state is DodgeState:
		if state_machine.current_state.isDodging:
			return "Dodge"
	return "None"

func randomize_move() -> String:
	var my_random_number = round(rng.randf_range(0, 1))
	if my_random_number == 1:
		# make a defense choice
		my_random_number = round(rng.randf_range(0, 1))
		if my_random_number == 0:
			return "DodgeState"
		elif my_random_number == 1:
			return "BlockState"
	return "None"

func on_sight_entered(body: Node3D):
	if body != self and body is PlayerEntity:
		navigation.register_target(body)
		primary_target = body
		provoked = true

func on_defeat() -> void:
	if animation_player.has_animation("Defeat"):
		print("Playing Defeat")
		animation_player.play("Defeat")
		is_dying = true

func on_hurtbox_hurt(hurtBy: HitboxComponent):
	# hit by itself
	if hurtBy == hitbox:
		return
	else:
		hurtbox.take_damage(hurtBy.damage_to_deal)

func on_anim_finish(anim: String) -> void:
	if anim == "Defeat":
		self.process_mode = Node.PROCESS_MODE_DISABLED

func on_anim_change(oldAnim: String, newAnim: String) -> void:
	if oldAnim == "Defeat":
		self.process_mode = Node.PROCESS_MODE_DISABLED
