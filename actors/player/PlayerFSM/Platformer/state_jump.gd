extends State

func enterState():
	PLAYER.velocity.y = PLAYER.JUMP_VELOCITY

func updateState(delta : float):
	if Input.is_action_just_released("move_up") and PLAYER.velocity.y < 0:
		PLAYER.velocity.y *= 0.5
	
	#Ceiling Bump
	if PLAYER.is_on_ceiling():
		PLAYER.velocity.y = 1
	
	movement(delta)
	PLAYER.move_and_slide()
	
	if PLAYER.velocity.y > 0 and not PLAYER.is_on_floor():
		transition.emit(self, "Fall")

func movement(delta : float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		PLAYER.velocity.x = move_toward(PLAYER.velocity.x, direction * PLAYER.MAX_SPEED, PLAYER.ACCELERATION * delta)
	else:
		PLAYER.velocity.x = move_toward(PLAYER.velocity.x, 0, PLAYER.FRICTION * delta)
