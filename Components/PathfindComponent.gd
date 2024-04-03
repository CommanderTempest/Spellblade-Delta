extends Node3D
class_name PathfindComponent

@export var navigation_agent_3d: NavigationAgent3D
@export var character: CharacterBody3D
@export var speed := 2.0

var spawn_pos: Vector3
var primary_target: CharacterBody3D
var tracking_target := false
var distance : float

func _ready():
	spawn_pos = owner.global_position

func _process(delta):
	if tracking_target:
		track_to_target(primary_target.global_position)

func _physics_process(delta):
	var next_position = navigation_agent_3d.get_next_path_position()
	var direction = character.global_position.direction_to(next_position)
	
	if primary_target:
		distance = character.global_position.distance_to(primary_target.global_position)
		
	if direction.is_zero_approx() or character.global_position == spawn_pos:
		pass
#		if walk_player.has_animation("Idle"):
#			walk_player.play("Idle")
	elif direction:
		look_at_target(-direction)
		character.velocity.x = direction.x * speed
		character.velocity.z = direction.z * speed
#		if walk_player.has_animation("Walk"):
#			walk_player.play("Walk")
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, speed)
		character.velocity.z = move_toward(character.velocity.z, 0, speed)

	character.move_and_slide()

func return_to_spawn():
	print("Disengaging")
	speed = 1.0
	navigation_agent_3d.target_position = spawn_pos
	unregister_target()
	
func register_target(character: CharacterBody3D):
	primary_target = character
	tracking_target = true

func unregister_target():
	tracking_target = false
	primary_target = null

func has_primary_target() -> bool:
	if primary_target:
		return true
	else:
		return false

func get_distance_to_target() -> float:
	return distance

func track_to_target(target: Vector3):
	navigation_agent_3d.target_position = target

func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	# prevents the enemy from tilting when player is on a different elevation
	adjusted_direction.y = 0 
	character.look_at(character.global_position + adjusted_direction, Vector3.UP, true)

func check_range(attack_range: float):
	if distance > attack_range:
		speed = 2.0
	else:
		speed = 1.0

func getNavAgent() -> NavigationAgent3D:
	return self.navigation_agent_3d
