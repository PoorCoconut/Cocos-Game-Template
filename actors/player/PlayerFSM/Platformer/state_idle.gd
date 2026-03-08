extends State
class_name PlayerIdle_Platformer

func enterState():
	pass

func updateState(_delta : float):
	
	PLAYER.move_and_slide()
	
	if Input.get_axis("move_left", "move_right"):
		transition.emit(self, "Run")
	elif Input.is_action_just_pressed("move_up"):
		transition.emit(self, "Jump")
	
	
