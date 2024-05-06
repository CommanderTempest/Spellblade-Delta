extends State
class_name StunState

const STUN_DURATION := 2.5 # in seconds, how long to stay stuck in this state
var stun_timer: Timer = Timer.new()
var is_stunned := false

func _ready() -> void:
	stun_timer.wait_time = STUN_DURATION
	add_child(stun_timer)
	stun_timer.timeout.connect(on_stun_timeout)

func Enter() -> void:
	stun_timer.start()
	anim.play("Idling")
	anim.play("Stunned")
	is_stunned = true
	print("Supposed to be stunned")
func Exit() -> void:
	pass
	
func on_stun_timeout() -> void:
	stun_timer.stop()
	is_stunned = false
	anim.play("Idling")
