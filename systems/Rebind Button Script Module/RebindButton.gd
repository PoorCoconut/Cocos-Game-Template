extends Button
class_name RebindButton

@export var action_name : String = ""

##The index of an input on a map that supports inputs.
@export var bind_index : int = 0 #This scales infinitely. Ex: You ca press Y, U, Right Click, A, B to do an action. 
#Don't forget to add indexes in the SettingsManager's slotted_binds

@export_group("Allowed Input Types")
@export var allow_keyboard : bool = true
@export var allow_mouse : bool = true
@export var allow_joypad : bool = true

var is_listening : bool = false
var current_event : InputEvent = null

func _ready() -> void:
	toggle_mode = false 
	
	# AUTO-DISABLE: If the developer locked all inputs in the Inspector, disable the button
	if not allow_keyboard and not allow_mouse and not allow_joypad:
		disabled = true
		focus_mode = Control.FOCUS_NONE # Prevents the controller/keyboard from highlighting it
		
	update_button_text()
	SettingsManager.controls_reset.connect(update_button_text)
	SettingsManager.keybinds_updated.connect(update_button_text)

func _pressed() -> void:
	is_listening = true
	text = "Press any key..."

func _input(event: InputEvent) -> void:
	if not is_listening: return
		
	var is_valid_input: bool = false
	if allow_keyboard and event is InputEventKey: is_valid_input = true
	elif allow_mouse and event is InputEventMouseButton: is_valid_input = true
	elif allow_joypad and event is InputEventJoypadButton: is_valid_input = true
		
	if is_valid_input and event.is_pressed():
		# Send the specific Slot Number (bind_index) to the Manager
		SettingsManager.update_keybind(action_name, bind_index, event)
		is_listening = false
		get_viewport().set_input_as_handled()

func update_button_text() -> void:
	if action_name == "":
		text = "Provide an action name!"
		return
	
	# Check our Dictionary to see if our specific slot has a key assigned
	if SettingsManager.slotted_binds.has(action_name) and SettingsManager.slotted_binds[action_name].has(bind_index):
		current_event = SettingsManager.slotted_binds[action_name][bind_index]
	else:
		current_event = null
		
	# Update visuals
	if current_event != null:
		text = current_event.as_text().trim_suffix(" - Physical")
	else:
		text = "Unassigned"
