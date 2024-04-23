extends State
class_name DodgeState

signal dodgeStateChanged

var dodge_cd: Timer = Timer.new()
var isDodging := false
var canDodge := true:
	set(value):
		canDodge = value
		dodgeStateChanged.emit()

func _ready():
	dodge_cd.wait_time = 3.0 # in seconds
	add_child(dodge_cd)
	dodge_cd.timeout.connect(on_dodge_cd_timeout)
	anim.animation_finished.connect(on_animation_finished)

func Enter():
	if canDodge:
		isDodging = true
		canDodge = false
		dodge_cd.start()
		if anim.has_animation("Dodge"):
			anim.play("Dodge")
		else:
			print(self.name + " has no animation: Dodge")
func Exit():
	pass

func getIsDodging():
	return isDodging

func on_dodge_cd_timeout():
	canDodge = true
	dodge_cd.stop()
	
func on_animation_finished(anim_name: String):
	if anim_name == "Dodge":
		isDodging = false
		transitioned.emit(self, "IdleState")
