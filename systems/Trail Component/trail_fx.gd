extends Line2D
class_name Trail

var queue : Array
@export var MAX_LENGTH : int = 5

func _process(_delta: float) -> void:
	var pos = _get_position()
	queue.push_front(pos)
	
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
	
	clear_points()
	
	for point in queue:
		add_point(point)

func _get_position():
	return get_global_mouse_position()
