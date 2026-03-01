extends State
class_name PlayerRun_TopDown

func enterState():
	pass

func updateState(delta: float):
	movement(delta)

func movement(delta: float):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		PLAYER.CUR_DIR = direction
		PLAYER.velocity = PLAYER.velocity.move_toward(direction * PLAYER.MAX_SPEED, PLAYER.ACCELERATION * delta)
	else:
		PLAYER.velocity = PLAYER.velocity.move_toward(Vector2.ZERO, PLAYER.FRICTION * delta)
	
	PLAYER.move_and_slide()
	
	if direction == Vector2.ZERO and PLAYER.velocity.length() < 5.0:
		transition.emit(self, "Idle")
