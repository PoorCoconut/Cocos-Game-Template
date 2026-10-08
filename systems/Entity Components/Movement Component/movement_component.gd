extends Node
class_name MovementComponent
@export var ENTITY : CharacterBody2D

@export_category("MOVEMENT STATS")
@export var MAX_SPEED : float
@export var FRICTION : float
@export var ACCELERATION : float

var base_friction : float
var current_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	base_friction = FRICTION

func accelerate_in_direction(direction: Vector2, delta: float) -> void:
	if direction != Vector2.ZERO:
		current_velocity = current_velocity.move_toward(direction.normalized() * MAX_SPEED, ACCELERATION * delta)
	else:
		apply_friction(delta)

func apply_friction(delta: float) -> void:
	current_velocity = current_velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func apply_slide_debuff(duration: float, target_friction: float = 300.0) -> void:
	FRICTION = target_friction
	
	# Wait for the duration to end
	await get_tree().create_timer(duration).timeout
	
	# Restore the component's original friction
	FRICTION = base_friction

func move() -> void:
	ENTITY.velocity = current_velocity
	ENTITY.move_and_slide()
	current_velocity = ENTITY.velocity

func apply_knockback(force: Vector2) -> void:
	current_velocity += force
