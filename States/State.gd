extends Node
class_name State

signal transitioned

@export var anim: AnimationPlayer
# character the state belongs to
@export var Character: CharacterBody3D

func _ready():
	if !Character:
		if self.get_parent().get_parent() is CharacterBody3D:
			Character = self.get_parent().get_parent()
		else:
			print_debug("Could not find CharacterBody3D for state: " + str(self.name))
	if !anim:
		anim = self.get_parent().get_parent().find_child("AnimationPlayer")

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass
