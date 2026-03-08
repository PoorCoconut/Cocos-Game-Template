extends Node
class_name StateMachine
signal state_changed(new_state: String)

@export var initial_state : State;
var states : Dictionary = {}; #It's like an array but you access stuff by it's key, in this case, the name
var cur_state;

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child; #Place in states dictionary
			child.transition.connect(change_state) #Connect the transition signal. When it detects the transition signal, call the change_state function, the parameters of the function is automatically placed as the arguments of the signal (self, "new state name")
	if initial_state:
		initial_state.enterState();
		cur_state = initial_state;

#Get the new state -> Exit the current state -> Enter the New State -> Set current state as new state 
func change_state(old_state:State, new_state_name:String):
	#Checks if there is a mismatch between the FSM's current state and the State expected to be active
	if old_state != cur_state:
		#print("Invalid change_state! Mismatch Error! Expected State is: " + old_state.name + " but Current State is: " + cur_state.name);
		return
	
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		#print("New state is empty or non-existent");
		return
	
	if cur_state:
		cur_state.exitState();
	
	new_state.enterState();
	cur_state = new_state;
	
	#Emit the change state signal
	emit_signal("state_changed", new_state_name)

#This is quite dangerous and unstable ... Call using force_change_state("name")
func force_change_state(new_state : String):
	var newState = states.get(new_state.to_lower())
	
	if !new_state:
		#print("New state is empty or non-existent");
		return
	if cur_state == newState:
		#print("State is same, aborting")
		return
	if cur_state:
		var exit_callable = Callable(cur_state, "exitState") #the current state's exit method
		exit_callable.call_deferred() #call it at the end of a frame
	newState.enterState() #Enter the forced new State
	cur_state = newState

func _process(delta: float) -> void:
	if get_parent().has_node("DebugStateLabel"):
		%DebugStateLabel.text = cur_state.name
	if cur_state:
		cur_state.updateState(delta)
