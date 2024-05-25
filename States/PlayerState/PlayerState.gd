extends Node
class_name PlayerState

var player_entity: PlayerEntity

func _ready():
	player_entity = self.owner
	set_physics_process(false)
	set_process_input(false)

func _notification(what):
	super.notification(what)
	
	if what == GameConstants.NOTIFICATION_ENTER_STATE:
		self.enter_state()
		set_physics_process(true)
		set_process_input(true)
	elif what == GameConstants.NOTIFICATION_EXIT_STATE:
		set_physics_process(false)
		set_process_input(false)

func enter_state() -> void:
	pass
