extends CanvasLayer
class_name PixelPerfectLayer

@export var main_camera : Camera2D
@export var pp_camera : Camera2D

@onready var sub_viewport : SubViewport = %SubViewport

func _ready() -> void:
	await get_tree().process_frame
	
	var pixel_perfect_stuff: Array = get_tree().get_nodes_in_group("pp")
	for thing in pixel_perfect_stuff:
		thing.call_deferred("reparent", sub_viewport, true)


func _process(delta: float) -> void:
	if !pp_camera or !main_camera: return
	pp_camera.set_global_transform(main_camera.get_global_transform())
