extends Node3D

@export var play := false

func _physics_process(delta):
	if play and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("slash")
