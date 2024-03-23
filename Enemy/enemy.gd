extends CharacterBody3D
class_name Enemy

const SPEED = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer

@export var max_hitpoints := 100
@export var attack_range := 1.5
@export var enemy_damage := 20
@export var aggro_range := 12.0

var player
var provoked := false
var hitpoints: int = max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			queue_free() #destroy self
		provoked = true

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	#animation_player.play("Idle")
	
func _process(delta) -> void:
	if provoked:
		navigation_agent_3d.target_position = player.global_position
	
func _physics_process(delta) ->void:
	var next_position = navigation_agent_3d.get_next_path_position()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = global_position.direction_to(next_position)
	var distance = global_position.distance_to(player.global_position)
	
	if (distance < aggro_range):
		provoked = true
	
	if provoked:
		if distance <= attack_range:
			animation_player.play("Attack")
			#attack()
	
	if direction:
		look_at_target(-direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	# prevents the enemy from tilting when player is on a different elevation
	adjusted_direction.y = 0 
	look_at(global_position + adjusted_direction, Vector3.UP, true)

func attack() -> void:
	#player.hitpoints -= enemy_damage
	#player.take_damage()
	print("?")

func take_damage() -> void:
	print("Took som damage! ENEMY")
