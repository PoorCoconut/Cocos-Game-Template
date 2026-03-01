extends State
class_name PlayerIdle_TopDown

func enterState():
	print("in the idle state")

func updateState(_delta : float):
	if(Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")):
		#Transition to Run State
		transition.emit(self, "Run")
