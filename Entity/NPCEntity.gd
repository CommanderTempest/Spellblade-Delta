extends CharacterEntity
class_name NPCEntity

## whether this entity will attack player(s) or not
@export var is_friendly := true

## Entity Dialogue
@export_multiline var dialogue: String

# whether the entity can be interacted with
var interactable: bool = (dialogue != null)
