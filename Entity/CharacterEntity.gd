extends BaseEntity
class_name CharacterEntity

signal entity_posture_changed(current_posture: int) # emits when posture is damaged

enum CharacterFlag {
	InCombat,
	Interacting,
	CannotMove,
	Dead,
	Resting,
	Stealthed
}

# Export Components
@export var hurtbox: HurtboxComponent
@export var health_component: HealthComponent = HealthComponent.new(1)
@export var posture_component: PostureComponent = PostureComponent.new()
# items currently equipped on this character
@export var equipped: EquipContainer = EquipContainer.new() 
# hitboxes this entity can use to deal damage
@export var hitbox_container: HitboxContainer = HitboxContainer.new()

# Export Variables
@export var speed: float = 2.0
@export var can_attack := false: # whether this entity is able to attack
	set(value):
		self.can_attack = value

@onready var animation_player = $AnimationPlayer
@onready var state_machine = $State_Machine

var can_tick_damage := true: # can deal damage to another entity
	set(value):
		self.can_tick_damage = value

func _ready() -> void:
	posture_component.postureChanged.connect(
		func(): entity_posture_changed.emit(
			posture_component.current_posture
		))

func damage_entity_health(damage: int) -> void:
	health_component.take_damage(damage)

func damage_entity_posture(damage: int) -> void:
	posture_component.take_posture_damage(damage)
