extends StatusEffect
class_name DamageStatusEffect

signal status_deal_damage(damage: int)

var duration: int = 5
var tick_rate: float = 1.0
var damage_per_tick: int = 1.0
var is_ticking := false

func _init(duration: int, tick_rate: float, damage_per_tick: int) -> void:
	super._init(duration)
	self.duration = duration
	self.tick_rate = tick_rate
	self.damage_per_tick = damage_per_tick

func _ready() -> void:
	pass

func begin_tick() -> void:
	is_ticking = true
	while is_ticking:
		await get_tree().create_timer(tick_rate).timeout
		status_deal_damage.emit(damage_per_tick)
