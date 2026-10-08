extends Area2D
class_name HitboxComponent

signal hit_landed(recoil_direction: Vector2)

@export var damage: int = 1
@export var knockback_force: float = 10.0

func emit_hit_landed(target_position: Vector2) -> void:
	var recoil_dir = (global_position - target_position).normalized()
	hit_landed.emit(recoil_dir)
