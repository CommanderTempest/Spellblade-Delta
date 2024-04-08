extends Node
class_name State

signal transitioned

@export var anim: AnimationPlayer
@export var Character: CharacterBody3D # character the state belongs to

func _ready():
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
