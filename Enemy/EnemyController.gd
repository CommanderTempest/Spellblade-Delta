extends CharacterBody3D
class_name EnemyController

signal AttackingEntity # signals to the mob group component that a target's been registered

@export var state_machine: StateMachine
@export var sightLine: Area3D
@export var navigation: PathfindComponent
@export var attack_range = 0.5
@export var hurtbox: HurtboxComponent
@export var hitbox: HitboxComponent

var primary_target: Player

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var rng = RandomNumberGenerator.new()
var spawn_pos: Vector3 
var provoked := false

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_pos = global_position
	sightLine.body_entered.connect(on_sight_entered)
	hurtbox.hurt.connect(on_hurtbox_hurt)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

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
	if body != self and body is Player:
		navigation.register_target(body)
		primary_target = body
		provoked = true

func on_hurtbox_hurt(hurtBy: HitboxComponent):
	# hit by itself
	if hurtBy == hitbox:
		return
	else:
		hurtbox.take_damage(hurtBy.damage_to_deal)
