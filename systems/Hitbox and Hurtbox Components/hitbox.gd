extends Area2D
class_name ComponentHitbox
var parent
var damage : int = 0
var knockback : float = 1.0
var weight : float = 0.0

func _ready() -> void:
	parent = self.get_parent()

func _on_area_entered(area: Area2D) -> void:
	var area_parent = area.get_parent()
	
	
	##DAMAGE
	if parent.has_method("get_damage"):
		damage = parent.get_damage()
	else:
		print(parent.name + " has no get damage function. Setting attack to 0.")
	if area_parent.has_method("take_damage"):
		area_parent.take_damage(damage)
	else:
		print(parent.name + " has no take damage function")
	
	##KNOCKBACK
	if parent.has_method("get_knockback"):
		knockback = parent.get_knockback()
	else:
		print(parent.name + " has no get knockback function. Setting knockback to 1.")
	
	if area_parent.has_method("get_weight"):
		weight = area.get_weight()
	else:
		print(area_parent.name + " has no get weight function. Setting weight to 0.")
	
	#IF THE ENTITY IS A PLAYER, deal knockback to it when PLAYER attacks
	if parent.has_method("apply_knockback"):
		var knockback_direction = (parent.global_position - global_position).normalized()
		parent.apply_knockback(knockback_direction, 50, 0.12)
	
	#Knocks this entity's TARGET back X distance based on its KNOCKBACK STAT.
	if area_parent.has_method("apply_knockback"):
		var knockback_direction = (area_parent.global_position - global_position).normalized()
		area_parent.apply_knockback(knockback_direction, knockback - weight, 0.12)
	else:
		print(area_parent.name , " has no knockback function, it will not receive knockback")
