extends State
class_name IdleState

@export var dodge_state: DodgeState

func Enter():
	print("Entered idle")
	if anim.has_animation("Idling"):
		anim.queue("Idling")
	else:
		print(self.name + " has no animation: Idling")
	
func Exit():
	if anim.current_animation == "Idling":
		anim.stop()
		#anim.play("Idling")

func Update(_delta: float):
	if Input.is_action_just_pressed("dodge"):
		print("Going to dodge")
		transitioned.emit(self, "DodgeState")
