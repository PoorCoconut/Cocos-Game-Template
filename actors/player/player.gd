extends CharacterBody2D
class_name Player

@export_category("PLAYER MOVEMENT")
@export var MAX_SPEED : float = 100
@export var ACCELERATION : float = 100
@export var FRICTION : float = 150

var CUR_DIR : Vector2

func _physics_process(_delta: float) -> void:
	print(velocity)
