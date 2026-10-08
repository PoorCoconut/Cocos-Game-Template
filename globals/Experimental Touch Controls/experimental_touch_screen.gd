extends CanvasLayer
@onready var atk_touch_screen: TouchScreenButton = %AtkTouchScreen
@onready var pause_touch_screen: TouchScreenButton = %PauseTouchScreen

var _stored_shoot_mouse_events: Array[InputEvent] = []
var _stored_move_mouse_events: Array[InputEvent] = []

var updown_toggle : bool = false
func _ready() -> void:
	hide()
	
	atk_touch_screen.pressed.connect(_on_atk_pressed)
	pause_touch_screen.pressed.connect(_on_pause_pressed)
	if updown_toggle:
		%UpButton.show()
		%DownButton.show()
		%UpTouchScreen.show()
		%DownTouchScreen.show()
	else:
		%UpButton.hide()
		%DownButton.hide()
		%UpTouchScreen.hide()
		%DownTouchScreen.hide()

func enable_touch_mode() -> void:
	_strip_mouse_bindings("shoot", _stored_shoot_mouse_events)
	_strip_mouse_bindings("move", _stored_move_mouse_events)
	show()

func disable_touch_mode() -> void:
	_restore_mouse_bindings("shoot", _stored_shoot_mouse_events)
	_restore_mouse_bindings("move", _stored_move_mouse_events)
	hide()

func _strip_mouse_bindings(action: StringName, storage: Array[InputEvent]) -> void:
	storage.clear()
	for event in InputMap.action_get_events(action):
		if event is InputEventMouseButton:
			storage.append(event)
	for event in storage:
		InputMap.action_erase_event(action, event)

func _restore_mouse_bindings(action: StringName, storage: Array[InputEvent]) -> void:
	for event in storage:
		InputMap.action_add_event(action, event)
	storage.clear()

func _press_action(action: StringName) -> void:
	var ev := InputEventAction.new()
	ev.action = action
	ev.pressed = true
	Input.parse_input_event(ev)

func _release_action(action: StringName) -> void:
	var ev := InputEventAction.new()
	ev.action = action
	ev.pressed = false
	Input.parse_input_event(ev)

func _on_atk_pressed() -> void:
	_press_action("shoot")
	_release_action("shoot")

func _on_pause_pressed() -> void:
	_press_action("pause")
	_release_action("pause")

func _on_toggle_up_down_pressed() -> void:
	print("pressed: ", updown_toggle)
	if updown_toggle:
		%UpButton.hide()
		%DownButton.hide()
		%UpTouchScreen.hide()
		%DownTouchScreen.hide()
		updown_toggle = false
	else:
		%UpButton.show()
		%DownButton.show()
		%UpTouchScreen.show()
		%DownTouchScreen.show()
		updown_toggle = true
