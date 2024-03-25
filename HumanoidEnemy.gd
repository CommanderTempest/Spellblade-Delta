extends BaseEnemy

@export var parry_cooldown := 3.5
@export var posture := 100:
	set(value):
		posture = value
		if posture <= 0:
			print(self.name + " is stunned")
			stun()
			posture = 100

# maybe here keep a list of humanoid mobs it spawned with, and if any of them see a target, they ALL go after it

#IMPORTANT: Maybe send a remote signal from player when they attack, if enemy is in range,
# maybe randomize a small chance to block

var parry_cd_timer: Timer
var stun_duration: Timer
var isStunned := false
var isBlocking := false
var isParrying := false
var canParry = true

func _ready():
	super._ready()
	
	parry_cd_timer.timeout.connect(parry_cd_end)
	parry_cd_timer.wait_time = parry_cooldown
	
	stun_duration.timeout.connect(stun_end)
	stun_duration.wait_time = 3 # in seconds

func _process(delta):
	super._process(delta)
	
	if super.getPrimaryTarget().getIsSwinging():
		# basically, if we're here, the target is swinging, so we want to block/parry
		# block/parry is randomized
		pass

func enemy_take_damage(damage: int):
	if isParrying:
		print(self.name + " parried!")
		# run particles for parry
	elif isBlocking:
		posture -= 20
	else:
		super.enemy_take_damage(damage)
		print("Does this run in addition to BaseEnemy?")
		
func stun():
	# run stun animation
	isStunned = true
	stun_duration.start()

#************SIGNALS*****************8

func parry_cd_end():
	canParry = true
	parry_cd_timer.stop()
	
func stun_end():
	isStunned = false
	stun_duration.stop()
