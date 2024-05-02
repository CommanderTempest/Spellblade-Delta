extends State
class_name BlockState

signal blockStateChanged

var block_cd: Timer = Timer.new()
var parry_length: Timer = Timer.new() # the length of time (seconds) you are parrying for
var isBlocking := false
var isParrying := false
var canBlock := true:
	set(value):
		canBlock = value
		blockStateChanged.emit()

func _ready():
	block_cd.wait_time = 2.0 # in seconds
	parry_length.wait_time = 0.5
	add_child(block_cd)
	add_child(parry_length)
	block_cd.timeout.connect(on_block_cd_timeout)
	parry_length.timeout.connect(on_parry_length_timeout)
	anim.animation_finished.connect(on_animation_finished)
	anim.animation_changed.connect(on_animation_changed)

func Enter():
	if canBlock:
		isBlocking = true
		canBlock = false
		
		if anim.has_animation("Parry"):
			parry_length.start()
			anim.play("Parry")
			anim.queue("HoldBlock")
		else:
			print(self.name + " has no animation: Parry")

func Exit():
	isBlocking = false
	block_cd.start()

func getIsBlocking():
	return isBlocking

func on_block_cd_timeout():
	canBlock = true
	block_cd.stop()

func on_parry_length_timeout():
	isParrying = false
	parry_length.stop()

func on_animation_finished(anim_name: String):
	if anim_name == "Parry":
		isParrying = false

# this signal runs when a queue is used
func on_animation_changed(old_anim, new_anim):
	if old_anim == "Parry":
		isParrying = false
