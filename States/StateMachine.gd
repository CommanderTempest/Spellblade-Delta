extends Node
class_name StateMachine

signal state_transition(new_state: State)

@export var initial_state: State

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	state_transition.emit(new_state)
	new_state.Enter()
	current_state = new_state

func getCurrentState() -> State:
	return current_state

func get_current_state_as_string() -> String:
	return self.current_state.name

func has_state(state_name: String) -> bool:
	if self.states.has(state_name):
		return true
	return false

func retrieve_state(state_name: String) -> State:
	if self.has_state(state_name):
		return self.states[state_name]
	else:
		print_debug("Could not find state: " + state_name)
		return null
