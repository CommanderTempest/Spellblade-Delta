extends CharacterEntity
class_name NPCEntity

# Factions mainly for future functionality for NPCs attacking each other
enum Factions {
	Bandit,
	Castle
	#Drundomore
}

enum NPCFlags {
	Idle
}

## whether this entity will attack player(s) or not
@export var is_friendly := true

## Entity Dialogue
@export_multiline var dialogue: String

# maybe add a controller, unsure how to handle due to possible
# multiple controllers, also not all NPCs may move

# whether the entity can be interacted with
var interactable: bool = (dialogue != null)
