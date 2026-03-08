extends State

func enterState():
	pass

func updateState(delta : float):
	movement(delta)
	PLAYER.move_and_slide()
	
	if PLAYER.is_on_floor():
		transition.emit(self, "Run")

func movement(delta : float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		PLAYER.velocity.x = move_toward(PLAYER.velocity.x, direction * PLAYER.MAX_SPEED, PLAYER.ACCELERATION * delta)
	else:
		PLAYER.velocity.x = move_toward(PLAYER.velocity.x, 0, PLAYER.FRICTION * delta)
