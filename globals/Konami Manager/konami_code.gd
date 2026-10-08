extends Resource
class_name KonamiCode

@export var code_name: String = "classic"
@export var sequence: Array[String] = ["up", "up", "down", "down", "left", "right", "left", "right", "shoot", "move"]
@export var input_timeout: float = 2.0
@export var single_use: bool = false # if true, can only be triggered once until reset

var used_up: bool = false
