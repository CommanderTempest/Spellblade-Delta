extends Area3D

@export var SpawnPos: Vector3

func _on_body_entered(body):
	if body is CharacterBody3D:
		if body.is_in_group("Player"):
			print("Player detected")
			body.global_position = SpawnPos
		else:
			print("Detected somethin?")
