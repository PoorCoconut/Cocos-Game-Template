extends Node

signal code_entered(code_name: String)

@export var codes: Array[KonamiCode] = []

var _progress: Dictionary = {}
var _last_input_time: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for code in codes:
		_progress[code] = 0

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed() or event.is_echo():
		return
	
	for code in codes:
		if code.single_use and code.used_up:
			continue
		_check_code(code, event)

func _check_code(code: KonamiCode, event: InputEvent) -> void:
	if code.sequence.is_empty():
		return
	
	var expected_action = code.sequence[_progress[code]]
	#print("Progress: ", _progress[code], " | Expected: ", expected_action, " | Event: ", event)
	
	if _progress[code] > 0 and _last_input_time.has(code):
		if Time.get_ticks_msec() - _last_input_time[code] > code.input_timeout * 1000:
			_progress[code] = 0
	
	if event.is_action_pressed(expected_action):
		_progress[code] += 1
		_last_input_time[code] = Time.get_ticks_msec()
		#print("MATCHED! New progress: ", _progress[code])
		
		if _progress[code] >= code.sequence.size():
			if code.single_use:
				code.used_up = true
			code_entered.emit(code.code_name)
			# Here is where you will play your konami code sfx
			_progress[code] = 0
	else:
		if event.is_action_pressed(code.sequence[0]):
			_progress[code] = 1
			_last_input_time[code] = Time.get_ticks_msec()
		else:
			_progress[code] = 0

func reset_used_codes() -> void:
	for code in codes:
		code.used_up = false
