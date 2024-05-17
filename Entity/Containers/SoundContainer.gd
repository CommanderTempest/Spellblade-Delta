extends Node
class_name SoundContainer

"""
This container will host various sound objects to play
"""
@export var sounds: Array[AudioStreamPlayer3D] = []

func Play(sound_to_play: String) -> void:
	pass
	#find the right sound and play it
	
	# could make it an array of SoundPlayer, which is a custom class with an Audio Stream player,
	# and a sound_name to make this easier?
