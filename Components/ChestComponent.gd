extends Node3D
class_name ChestComponent
@export var loot_hitbox: Area3D

var target: Player

"""
Might want to rename this to loot component
"""

func _ready():
	loot_hitbox.body_entered.connect(_on_body_entered)
	loot_hitbox.body_exited.connect(_on_body_exited)
	# randomize some loot in here or sumthin

func _on_body_entered(body: CharacterBody3D):
	if body is Player and !target:
		target = body
		print("Player is in vicinity of chest")
		# access some UI to display on player

# unregister target and stop displaying UI
func _on_body_exited(body: CharacterBody3D):
	if target:
		if body == target:
			target = null
			# stop displaying some UI
