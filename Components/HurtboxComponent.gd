extends Area3D
class_name HurtboxComponent

signal trigger_hit(otherArea: HitboxComponent)

var canTakeDamage := false # dunno if I need this

var is_in_area := false

func _ready():
	area_entered.connect(entered_hurtbox)
	area_exited.connect(exited_hurtbox)

func entered_hurtbox(otherArea: Area3D):
	if otherArea is HitboxComponent:
		is_in_area = true
		trigger_hit.emit(otherArea)

func exited_hurtbox(otherArea: Area3D) -> void:
	is_in_area = false

