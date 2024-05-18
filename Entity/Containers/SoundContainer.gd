extends Node3D
class_name SoundContainer

"""
This container will host various sound objects to play
"""

@export var sounds: Array[AudioStreamPlayer3D] = []

func play_sound(sound_to_play: String) -> void:
	for sound in sounds:
		if sound.name.to_lower() == sound_to_play.to_lower():
			sound.play()
	
	# could make it an array of SoundPlayer, which is a custom class with an Audio Stream player,
	# and a sound_name to make this easier?
