extends Area2D
class_name CameraLimitZone

@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var camera = get_viewport().get_camera_2d()
		
		if camera and camera.has_method("apply_room_limits"):
			var shape = collision_shape.shape as RectangleShape2D
			if shape == null:
				push_error("CameraLimitZone requires a RectangleShape2D!")
				return
				
			# Calculate the absolute world coordinates of the 4 walls
			var center = collision_shape.global_position
			var extents = shape.size / 2.0
			
			var left_wall = int(center.x - extents.x)
			var right_wall = int(center.x + extents.x)
			var top_wall = int(center.y - extents.y)
			var bottom_wall = int(center.y + extents.y)
			
			# Send the walls to the camera!
			camera.apply_room_limits(left_wall, right_wall, top_wall, bottom_wall)
