extends State
class_name IdleState

func Enter():
	if anim.has_animation("Idling"):
		anim.queue("Idling")
	else:
		print(self.name + " has no animation: Idling")
	
func Exit():
	if anim.current_animation == "Idling":
		anim.stop()
		#anim.play("Idling")

func Update(_delta: float):
	pass
