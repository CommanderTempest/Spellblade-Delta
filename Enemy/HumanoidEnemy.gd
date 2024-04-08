extends BaseEnemy
#
#@export var sparks: PackedScene
#@export var parry_cooldown := 3.5
#@export var posture := 100:
#	set(value):
#		posture = value
#		if posture <= 0:
#			print(self.name + " is stunned")
#			stun()
#			posture = 100
#
#@onready var dodge_cd = $Timers/Dodge_CD
#@onready var block_cd = $Timers/Block_CD
#@onready var swing_cd = $Timers/Swing_CD
#@onready var combo_timer = $Timers/ComboTimer
#@onready var parry_timer = $Timers/ParryTimer
#@onready var stun_duration = $Timers/StunDuration
#
#
## maybe here keep a list of humanoid mobs it spawned with, and if any of them see a target, they ALL go after it
#
##IMPORTANT: Maybe send a remote signal from player when they attack, if enemy is in range,
## maybe randomize a small chance to block
#
#var rng = RandomNumberGenerator.new()
#var weapon: Area3D # the weapon currently equipped
#var isBlocking := false
#var isParrying := false
#var isDodging := false
#var isStunned := false
#
#var canBlock := true 
#var canDodge := true
#
#var combo := 1
#
#func _ready():
#	super._ready()
#
#	weapon = self.attack_parts[0]
#
#	# connect all these automatically so we don't have to 
#	# manually do it on every new mob type
#	self.animation_player.animation_finished.connect(_on_animation_player_animation_finished)
#
#func _process(delta):
#	super._process(delta)
#
##	if super.getPrimaryTarget():
##		if super.getPrimaryTarget().getIsSwinging():
##			defend()
#
#func attack() -> void:
#	if canAttack:
#		isAttacking = true
#		canAttack = false
#		if self.animation_player.has_animation("Attack1"):
#			animation_player.play("Attack1")
#		if self.animation_player.has_animation("Attack2"):
#			animation_player.queue("Attack2")
#			isAttacking = true
#		if self.animation_player.has_animation("Attack3"):
#			animation_player.queue("Attack3")
#
#func defend():
#	# basically, if we're here, the target is swinging, so we want to block/parry
#	# block/parry is randomized
#	if not isBlocking and not isDodging and not isAttacking and not isStunned:
#		randomize_move()
#
#func randomize_move():
#	var my_random_number = round(rng.randf_range(0, 1))
#	if my_random_number == 1:
#		# make a defense choice
#		my_random_number = round(rng.randf_range(0, 1))
#		if my_random_number == 0 and canDodge:
#			dodge()
#		elif my_random_number == 1 and canBlock:
#			block()
#
#func dodge() -> void:
#	isDodging = true
#	canDodge = false
#	if self.animation_player.has_animation("Dodge"):
#		animation_player.play("Dodge")
#		dodge_cd.start()
#
#func block() -> void:
#	isBlocking = true
#	isParrying = true
#	canBlock = false
#	parry_timer.start()
#	animation_player.play("Block")
#	animation_player.queue("HoldBlock")
#
#func enemy_take_damage(damage: int):
#	if isParrying:
#		print(self.name + " parried!")
#		var spark: GPUParticles3D = sparks.instantiate()
#		spark.amount = 20
#		add_child(spark)
#		spark.global_position = weapon.global_position
#	elif isDodging:
#		print(self.name + " dodged!")
#	elif isBlocking:
#		posture -= 20
#		var spark: GPUParticles3D = sparks.instantiate()
#		add_child(spark)
#		spark.global_position = weapon.global_position
#	else:
#		super.enemy_take_damage(damage)
#
#func stun():
#	# run stun animation
#	isStunned = true
#	stun_duration.start()
#
#func _on_dodge_cd_timeout():
#	canDodge = true
#	dodge_cd.stop()
#
#func _on_block_cd_timeout():
#	canBlock = true
#	block_cd.stop()
#
#func _on_swing_cd_timeout():
#	canAttack = true
#	swing_cd.stop()
#	# maybe refactor this to: if left clicked again, wait for anim to finish
#	# then combo into second move
#
#func _on_combo_timer_timeout():
#	combo_timer.stop()
#	combo = 1
#	animation_player.play("Idling")
#
#func _on_parry_timer_timeout():
#	isParrying = false
#	parry_timer.stop()
#
## ceases operations on the animation player
#func _on_animation_player_animation_finished(anim_name):
#	# player is no longer dodging
#	if anim_name == "Dodge":
#		print("Dodge Finished: " + self.name)
#		isDodging = false
#	elif anim_name == "HoldBlock":
#		isBlocking = false
#		isParrying = false
#	elif anim_name == "Attack1" or anim_name == "Attack2" or anim_name == "Attack3":
#		#isAttacking = false
#		pass
#
##************SIGNALS*****************8
#
#func stun_end():
#	isStunned = false
#	posture = 100
#	stun_duration.stop()
