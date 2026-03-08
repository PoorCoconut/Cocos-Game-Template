extends Player
class_name PlayerPlatformer

@export var JUMP_VELOCITY : float = -200
@export var GRAVITY : float = 300

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	move_and_slide()
