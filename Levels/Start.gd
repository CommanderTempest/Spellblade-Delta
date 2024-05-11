extends Button

# starts the Asorea Demo Map

func _on_pressed():
	get_tree().change_scene_to_file("res://Levels/asorea.tscn")
