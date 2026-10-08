extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var movement_component: MovementComponent
@export var weight: float = 10.0
@export var iframe : float = 0.3
var is_invincible: bool = false

signal knockback_received(direction: Vector2, force: float)
func _on_area_entered(area: Area2D) -> void:
	if is_invincible:
		return
	
	if area is HitboxComponent:
		is_invincible = true
		var hitbox = area as HitboxComponent
		if health_component:
			#print(get_parent().name + " hit for " + str(hitbox.damage) + " damage")
			health_component.take_damage(hitbox.damage)
		
		var knockback_dir = (global_position - hitbox.global_position).normalized()
		var final_knockback = max(0.0, hitbox.knockback_force - weight)
		
		if movement_component:
			movement_component.apply_knockback(knockback_dir * final_knockback)
		
		knockback_received.emit(knockback_dir, final_knockback)
		
		hitbox.emit_hit_landed(global_position)
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		await get_tree().create_timer(iframe).timeout
		if not is_instance_valid(self) or not is_inside_tree():
			return
		set_deferred("monitorable", true)
		set_deferred("monitoring", true)
		is_invincible = false
