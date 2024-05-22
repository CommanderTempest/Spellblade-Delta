extends CharacterEntity
class_name NPCEntity

# Factions mainly for future functionality for NPCs attacking each other
enum Factions {
	Bandit, ## Bandit Faction for Asorea
	Castle, ## Castle Faction in Asorea
	Friendly ## Friendly to player
	#Drundomore
}

enum NPCFlags {
	Idle
}

## whether this entity will attack player(s) or not
#@export var is_friendly := true May end up being dependent on the faction
@export var faction: Factions ## Faction the entity belongs to

## Entity Dialogue
@export_multiline var dialogue: String

@export_group("Combat")
@export var attack_range: float = 0.5
@export var follow_distance: float = 10.0
@export var max_distance: float = 10.0 ## the distance at which a player is no longer seen

@onready var sight: Area3D = $Sight
@onready var sight_detection: RayCast3D = $SightDetection
@onready var navigation_agent_3d = $NavigationAgent3D

# maybe add a controller, unsure how to handle due to possible
# multiple controllers, also not all NPCs may move

## targets this NPC is currently hostile with
var targets: Array[CharacterEntity] = []
var primary_target: CharacterEntity ## the target the NPC is chasing

# whether the entity can be interacted with
var interactable: bool = (dialogue != null)

func _physics_process(delta) -> void:
	if self.can_make_action():
		if primary_target:
			navigation_agent_3d.target_position = primary_target.global_position
			if is_in_attack_range():
				self.transition_state("AttackState")

func disable_controller() -> void:
	pass

func add_target(target: CharacterEntity) -> void:
	self.enter_combat()
	if !primary_target:
		primary_target = target
	targets.append(target)

## clear the targets array
func clear_targets() -> void:
	targets.clear()
	primary_target = null

func get_closest_target() -> CharacterEntity:
	if targets.size() > 0:
		var closest_distance = self.global_position.distance_to(targets[0].global_position)
		var target_to_return = targets[0]
		for target in targets:
			var distance = self.global_position.distance_to(target.global_position)
			if  distance < closest_distance:
				closest_distance = distance
				target_to_return = target
		return target_to_return
	print_debug("No targets found")
	return null

func is_in_attack_range() -> bool:
	if self.get_distance_to_primary_target() < self.attack_range:
		return true
	return false

func is_out_of_range() -> bool:
	if get_distance_to_primary_target() > self.max_distance:
		return true
	return false

func get_distance_to_primary_target() -> float:
	if primary_target:
		return self.global_position.distance_to(primary_target.global_position)
	return -1

func return_to_spawn() -> void:
	self.exit_combat()
	self.clear_targets()
	navigation_agent_3d.target_position = self.spawn_position

# *******  EVENTS  ********

func _on_sight_body_entered(other_body: Node3D):
	if other_body is CharacterEntity:
		if other_body is PlayerEntity:
			if not self.faction == Factions.Friendly:
				self.add_target(other_body)
		elif other_body is NPCEntity:
			if other_body.faction != self.faction:
				self.add_target(other_body)
