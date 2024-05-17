extends Node
class_name StatusEffect

var status_name: String
var status_duration: int = 5

var duration_timer = Timer.new()

func _init(duration: int) -> void:
	self.status_duration = duration

func _ready() -> void:
	if status_duration > 0:
		duration_timer.wait_time = status_duration
		duration_timer.timeout.connect(duration_timer_timeout)
		duration_timer.start()
	else:
		# permanent status effect until removed
		pass

func status_end() -> void:
	self.queue_free()

func duration_timer_timeout() -> void:
	duration_timer.stop()
	self.status_end()
