extends State
class_name AttackState

var combo_timer: Timer = Timer.new()
var isSwinging := false
var canSwing := true
var combo := 1

func _ready():
	combo_timer.wait_time = 1
	add_child(combo_timer)
	combo_timer.timeout.connect(on_combo_timer_timeout)
	anim.animation_finished.connect(on_animation_finished)
	#anim.animation_changed.connect(on_animation_changed)

func Enter():
	if anim.has_animation("Attack" + str(combo)):
		isSwinging = true
		canSwing = false
		anim.play("Attack" + str(combo))
		combo += 1

func Exit():
	isSwinging = false
	canSwing=true

func on_combo_timer_timeout():
	combo_timer.stop()
	combo = 1
	canSwing = true
	isSwinging = false
	transitioned.emit(self, "IdleState")

func on_animation_finished(anim_name: String):
	if (anim_name == "Attack1" or anim_name == "Attack2"):
		combo_timer.start()
		canSwing = true
		transitioned.emit(self, "HoldState")
	if (anim_name == "Attack3"):
		combo = 1
		transitioned.emit(self, "IdleState")

func on_animation_changed():
	print("am i here just to suffer")


