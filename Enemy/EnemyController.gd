extends CharacterBody3D
class_name EnemyController

@export var state_machine: StateMachine
@export var sightLine: Area3D
@export var navigation: PathfindComponent
@export var attack_range = 0.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var spawn_pos: Vector3 
var provoked := false

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_pos = global_position
	sightLine.body_entered.connect(on_sight_entered)

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

		if navigation.get_distance_to_target() > attack_range * 2:
			print("Out of range")
			print(str(navigation.get_distance_to_target()) + " is distance " + str(attack_range * 2))
			navigation.return_to_spawn()
			state_machine.on_child_transition(state_machine.current_state, "IdleState")

		if provoked:
			if navigation.get_distance_to_target() <= attack_range:
				state_machine.on_child_transition(state_machine.current_state, "AttackState")

func on_sight_entered(body: Node3D):
	if body is CharacterBody3D:
		navigation.register_target(body)
		provoked = true
