extends State
class_name HoldState

"""
HoldState's current purpose is to hold a swing animation
in the middle of the combo before switching it back
This makes the animation look just a little better
"""

var duration: Timer = Timer.new()

func _ready():
	duration.wait_time = 0.4
	add_child(duration)
	duration.timeout.connect(on_duration_timeout)

func Enter():
	duration.start()
	
func on_duration_timeout():
	duration.stop()
	transitioned.emit(self, "IdleState")
