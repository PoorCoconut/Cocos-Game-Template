extends CanvasLayer
@onready var background : ColorRect = $Background

func _ready() -> void:
	reset()

func trans_in(trans_time : float = 1) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_property(background.material, "shader_parameter/progress", 0.5, trans_time).from(0.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	return tween

func trans_out(trans_time : float = 1) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_property(background.material, "shader_parameter/progress", 1.0, trans_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	return tween

func reset() -> void:
	background.material.set_shader_parameter("progress", 0.0)
