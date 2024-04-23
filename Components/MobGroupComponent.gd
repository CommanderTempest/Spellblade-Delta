extends Node
class_name MobGroupComponent

"""
This class oversees all the 'hostile' or fighting entities on a map
and gets their targets, if multiple are attacking the same target,
this system will fetch one of them to engage whilst the others circle around.

If one's HP gets too low, the entities will swap out
"""


# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_tree().get_nodes_in_group("Enemy"):
		if node is EnemyController:
			node.AttackingEntity.connect(process_attacking_group)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_attacking_group(enemy: EnemyController) -> void:
	pass
