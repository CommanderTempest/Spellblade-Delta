extends CharacterBody3D

signal toggle_conversation()

func player_interact() -> void:
	# going to need to pass in some dialogue, maybe fetch from a JSON in here
	toggle_conversation.emit()
