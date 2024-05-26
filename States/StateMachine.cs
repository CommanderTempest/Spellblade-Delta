using System.Linq;
using Godot;

public partial class StateMachine : Node
{
	[Signal]
	public delegate void stateTransitionEventHandler(PlayerState newState);

	[Export] PlayerState initialState;

	private PlayerState currentState;
	private PlayerState[] states;

    public override void _Ready()
    {
		foreach(PlayerState state in GetChildren())
		{
			states.Append<PlayerState>(state);
		}

        foreach (PlayerState state in states)
		{
			state.Notification(GameConstants.NOTIFICATION_EXIT_STATE);
		}
		currentState.Notification(GameConstants.NOTIFICATION_ENTER_STATE);
    }

	public void SwitchState<T>()
	{
		PlayerState newState = null;
		foreach (PlayerState state in states)
		{
			if (state is T)
			{
				newState = state;
			}
		}

		if (newState == null) {return;}

		currentState.Notification(GameConstants.NOTIFICATION_EXIT_STATE);
		currentState = newState;
		currentState.Notification(GameConstants.NOTIFICATION_ENTER_STATE);
	}
}

// extends Node
// class_name StateMachine

// signal state_transition(new_state: State)

// @export var initial_state: State

// var current_state : State
// var states : Dictionary = {}

// func _ready():
// 	for child in get_children():
// 		if child is State:
// 			states[child.name.to_lower()] = child
// 			child.transitioned.connect(on_child_transition)
	
// 	if initial_state:
// 		initial_state.Enter()
// 		current_state = initial_state

// func _process(delta):
// 	if current_state:
// 		current_state.Update(delta)

// func _physics_process(delta):
// 	if current_state:
// 		current_state.Physics_Update(delta)

// func on_child_transition(state, new_state_name):
// 	if state != current_state:
// 		return
	
// 	var new_state = states.get(new_state_name.to_lower())
// 	if !new_state:
// 		return
	
// 	if current_state:
// 		current_state.Exit()
// 	state_transition.emit(new_state)
// 	new_state.Enter()
// 	current_state = new_state

// func getCurrentState() -> State:
// 	return current_state

// func get_current_state_as_string() -> String:
// 	return self.current_state.name

// func has_state(state_name: String) -> bool:
// 	if self.states.has(state_name):
// 		return true
// 	return false

// func retrieve_state(state_name: String) -> State:
// 	if self.has_state(state_name):
// 		return self.states[state_name]
// 	else:
// 		print_debug("Could not find state: " + state_name)
// 		return null
