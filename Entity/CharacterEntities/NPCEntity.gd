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

var rng = RandomNumberGenerator.new()

# whether the entity can be interacted with
var interactable: bool = (dialogue != null)

func _ready() -> void:
	self.hurtbox.trigger_hit.connect(on_hit)

func _process(_delta) -> void:
	if primary_target:
		if primary_target.flags.has(primary_target.CharacterFlag.Defeated):
			return_to_spawn()

func _physics_process(delta) -> void:
	if self.can_make_action():
		if primary_target:
			navigation_agent_3d.target_position = primary_target.global_position
			self.move_to_target()
			if self.is_out_of_range():
				self.targets.remove_at(self.targets.find(self.primary_target))
				
				var closest_target = self.get_closest_target()
				if  closest_target != null:
					primary_target = closest_target
				else:
					self.return_to_spawn()
			elif not self.is_in_attack_range():
				# 1.0 is jump height here
				if primary_target.global_position.y - 1.0 >= self.global_position.y:
					if self.climb_detector.is_colliding() and not self.state_machine.current_state is ClimbState:
						self.transition_state("ClimbState")
				elif primary_target.global_position.y >= self.global_position.y:
					self.transition_state("JumpState")
			else:
				self.process_move()

func process_move() -> void:
	if is_in_attack_range() and primary_target.flags.has(primary_target.CharacterFlag.Attacking):
		var move_to_make = self.randomize_move()
		if move_to_make != "None":
			self.transition_state(move_to_make)
	elif is_in_attack_range():
		self.transition_state("AttackState")

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

func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	# prevents the enemy from tilting when player is on a different elevation
	adjusted_direction.y = 0 
	self.look_at(self.global_position + adjusted_direction, Vector3.UP, true)

func move_to_target() -> void:
	var next_position = navigation_agent_3d.get_next_path_position()
	var direction = self.global_position.direction_to(next_position)
	var distance: float = 0

	if primary_target:
		distance = self.global_position.distance_to(primary_target.global_position)
		
	if direction.is_zero_approx() or self.global_position == self.spawn_position:
		pass
#		if walk_player.has_animation("Idle"):
#			walk_player.play("Idle")
	elif direction:
		look_at_target(-direction)
		self.velocity.x = direction.x * speed
		self.velocity.z = direction.z * speed
#		if walk_player.has_animation("Walk"):
#			walk_player.play("Walk")
	else:
		self.velocity.x = move_toward(self.velocity.x, 0, speed)
		self.velocity.z = move_toward(self.velocity.z, 0, speed)

	self.move_and_slide()

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
	self.clear_battle_flags()
	self.transition_state("IdleState")
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

# override
func on_hit(otherArea: HitboxComponent) -> void:
	super.on_hit(otherArea)
	var other_owner = otherArea.getOwner()
	if other_owner != null:
		primary_target = other_owner
		self.add_target(other_owner)
