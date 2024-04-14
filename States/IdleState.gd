extends State
class_name IdleState

func Enter():
	if Character:
		Character.gravity = 9.8 # make sure gravity is on
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
