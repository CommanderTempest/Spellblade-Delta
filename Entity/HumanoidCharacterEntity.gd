extends CharacterEntity
class_name HumanoidCharacterEntity

signal entity_posture_changed(current_posture: int) # emits when posture is damaged

@export var posture_component: PostureComponent

func _ready() -> void:
	posture_component.postureChanged.connect(
		func(): entity_posture_changed.emit(
			posture_component.current_posture
		))
