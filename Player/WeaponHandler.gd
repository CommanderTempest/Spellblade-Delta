extends Node3D
class_name WeaponHandler

static var weapon_cooldowns := {
	"Sword": 0.6,
	"Spear": 0.8
}

static func has_weapon(type: String) -> bool:
	if weapon_cooldowns[type]:
		return true
	else:
		return false

static func get_cd(type: String) -> float:
	if has_weapon(type):
		return weapon_cooldowns[type]
	else:
		return 1.0
