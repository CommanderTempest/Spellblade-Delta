extends Area3D


func _on_body_entered(body):
	var player
	if body.is_in_group("Enemy"):
		print("Hit enemy")
	if body.is_in_group("Player"):
		player = get_tree().get_first_node_in_group("Player")
		if player:
			player.take_damage()
		else:
			print("Where player?")
