extends BaseEntity
class_name CharacterEntity

signal entity_posture_changed(current_posture: int) # emits when posture is damaged

enum CharacterFlag {
	InCombat,
	Interacting,
	Defeated,
	Resting,
	Stealthed,
	Stunned,
	Blocking,
	Attacking,
	Parrying,
	Dodging
}

const COMBAT_TIMER_DURATION := 10.0

@export_group("Components")
@export var hurtbox: HurtboxComponent
@export var health_component: HealthComponent = HealthComponent.new(1)
@export var posture_component: PostureComponent = PostureComponent.new(100)

@export_group("Containers")
## items currently equipped on this character
@export var equipped: EquipContainer = EquipContainer.new()
## hitboxes this entity can use to deal damage
@export var hitbox_container: HitboxContainer = HitboxContainer.new()
@export var sounds: SoundContainer = SoundContainer.new()

@export_group("Character Variables")
@export var speed: float = 2.0
@export var can_attack := false: ## whether this entity is able to attack
	set(value):
		self.can_attack = value
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $State_Machine

var flags: Array[CharacterFlag] = []
var can_tick_damage := true: # can deal damage to another entity
	set(value):
		self.can_tick_damage = value

var in_combat_timer: Timer = Timer.new()

func _ready() -> void:
	self.posture_component.postureChanged.connect(
		func(): 
			if posture_component.current_posture <= 0:
				flags.append(CharacterFlag.Stunned)
			entity_posture_changed.emit(
				posture_component.current_posture
			))
	self.health_component.defeated.connect(on_character_defeat)
	self.hurtbox.trigger_hit.connect(on_hit)
	self.state_machine.state_transition.connect(on_state_transition)
	
	self.in_combat_timer.wait_time = COMBAT_TIMER_DURATION
	self.in_combat_timer.timeout.connect(on_combat_timer_timeout)
	self.add_child(in_combat_timer)

func _process(delta: float) -> void:
	pass

func damage_entity_health(damage: int) -> void:
	self.enter_combat()
	self.health_component.take_damage(damage)

func damage_entity_posture(damage: int) -> void:
	self.enter_combat()
	self.posture_component.take_posture_damage(damage)

func enter_combat() -> void:
	self.flags.append(CharacterFlag.InCombat)
	self.health_component.stop_regen()
	self.posture_component.stop_regen()
	self.in_combat_timer.start()

func exit_combat() -> void:
	self.flags.remove_at(flags.find(CharacterFlag.InCombat))
	self.health_component.begin_regen()
	self.posture_component.begin_regen()

## removes flags: Attacking,Blocking,Parrying,Dodging from entity
func clear_battle_flags() -> void:
	self.flags.remove_at(flags.find(CharacterFlag.Attacking))
	self.flags.remove_at(flags.find(CharacterFlag.Blocking))
	self.flags.remove_at(flags.find(CharacterFlag.Parrying))
	self.flags.remove_at(flags.find(CharacterFlag.Dodging))
	self.flags.remove_at(flags.find(CharacterFlag.Stunned))

#*******EVENTS********

func on_hit(otherArea: HitboxComponent):
	if not hitbox_container.is_in_container(otherArea):
		if self.flags.has(CharacterFlag.Dodging):
			print("Dodged!!")
		elif self.flags.has(CharacterFlag.Parrying):
			print("PARRIED!?!")
		elif self.flags.has(CharacterFlag.Blocking):
			self.damage_entity_posture(otherArea.get_random_damage_to_deal())
		else:
			self.damage_entity_health(otherArea.get_random_damage_to_deal())
	else:
		print_debug(self.name + " is hitting itself")

func on_combat_timer_timeout() -> void:
	self.in_combat_timer.stop()
	self.exit_combat()

func on_state_transition(new_state: State) -> void:
	if new_state is IdleState:
		self.clear_battle_flags()
	elif new_state is AttackState:
		self.flags.append(CharacterFlag.Attacking)
	elif new_state is StunState:
		self.flags.append(CharacterFlag.Stunned)
	elif new_state is BlockState:
		self.flags.append(CharacterFlag.Blocking)
	elif new_state is DodgeState:
		self.flags.append(CharacterFlag.Dodging)

func on_character_defeat() -> void:
	self.flags.append(CharacterFlag.Defeated)
	if self.animation_player.has_animation("Defeat"):
		self.animation_player.play("Defeat")

