extends BaseCharacterEntity
class_name CharacterEntity

@export var can_attack := false
@export var hurtbox: HurtboxComponent
@export var health_component: HealthComponent

@onready var animation_player = $AnimationPlayer

var can_tick_damage := true # can deal damage to another entity

func get_hurtbox() -> HurtboxComponent:
	return self.hurtbox
	
func set_can_attack(can_attack: bool) -> void:
	self.can_attack = can_attack
