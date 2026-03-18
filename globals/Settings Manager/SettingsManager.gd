extends Node

const SETTINGS_FILE = "user://settings.json"

#SETTINGS VARIABLES [should have defaults]
var master_vol: float = 1.0
var music_vol: float = 1.0
var sfx_vol: float = 1.0
var screen_shake: bool = true

func _ready():
	for action in InputMap.get_actions():
		slotted_binds[action] = {}
		var events = InputMap.action_get_events(action)
		for i in range(events.size()):
			slotted_binds[action][i] = events[i]
	load_settings()

func save_settings():
	# 1. Pack everything into a Dictionary
	var data = {
		"master_vol": master_vol,
		"music_vol": music_vol,
		"sfx_vol": sfx_vol,
		"screen_shake": screen_shake
	}
	
	# 2. Open the file and convert the Dictionary to a JSON string
	var file = FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t")) # The "\t" makes it format beautifully in Notepad!
	
	# 3. Apply the audio changes immediately
	apply_audio_settings()

func load_settings():
	# If this is their very first time playing, save the defaults to make the file!
	if not FileAccess.file_exists(SETTINGS_FILE):
		save_settings()
		return
		
	var file = FileAccess.open(SETTINGS_FILE, FileAccess.READ)
	var json_text = file.get_as_text()
	var data = JSON.parse_string(json_text)
	
	# Extract the data back into our variables
	master_vol = data.get("master_vol", 1.0)
	music_vol = data.get("music_vol", 1.0)
	sfx_vol = data.get("sfx_vol", 1.0)
	screen_shake = data.get("screen_shake", true)
	
	apply_audio_settings()
	load_keybinds()

func apply_audio_settings():
	# Godot audio uses Decibels (-80 to 0), not percentages (0.0 to 1.0).
	# linear_to_db() perfectly translates your slider percentage into Decibels!
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_vol))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_vol))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_vol))

##CONTROLS SETTINGS
signal controls_reset
signal keybinds_updated

var config = ConfigFile.new()
const SAVE_PATH : String = "user://settings.cfg"
var slotted_binds: Dictionary = {}

func reset_keybinds_to_default() -> void:
	if config.has_section("Keybinds"):
		config.erase_section("Keybinds")
		config.save(SAVE_PATH)
	
	InputMap.load_from_project_settings()
	
	# Re-populate our dictionary from the fresh project settings
	slotted_binds.clear()
	for action in InputMap.get_actions():
		slotted_binds[action] = {}
		var events = InputMap.action_get_events(action)
		for i in range(events.size()):
			slotted_binds[action][i] = events[i]
			
	controls_reset.emit()

func update_keybind(target_action: String, target_index: int, new_event: InputEvent) -> void:
	#Hunt down duplicates and nuke them
	for action in slotted_binds:
		# Protect built-in UI actions from being accidentally cleared, unless we are explicitly targeting them
		if action.begins_with("ui_") and action != target_action:
			continue
			
		for index in slotted_binds[action]:
			var event = slotted_binds[action][index]
			if event != null and event.is_match(new_event):
				# Duplicate found! Set its slot to null (Unassigned)
				slotted_binds[action][index] = null 
				
	#Assign to target slots
	if not slotted_binds.has(target_action):
		slotted_binds[target_action] = {}
	slotted_binds[target_action][target_index] = new_event
	
	#Sync and save
	_sync_inputmap_to_slots()
	config.set_value("Keybinds", "slots", slotted_binds)
	config.save(SAVE_PATH)
	
	#Emit signal
	keybinds_updated.emit()

#Simpler Design of update_keybind. Does not support duplicate guarding [players can bind 2 actions in 1 button]
#func save_keybind(action_name: String, event : InputEvent) -> void:
	#config.set_value("Keybinds", action_name, event)
	#config.save(SAVE_PATH)

# Wipes the engine's current memory and perfectly reconstructs it from our Dictionary
func _sync_inputmap_to_slots() -> void:
	for action in slotted_binds:
		InputMap.action_erase_events(action)
		for index in slotted_binds[action]:
			var event = slotted_binds[action][index]
			# Only add the event to the engine if the slot actually has a key in it
			if event != null:
				InputMap.action_add_event(action, event)

func load_keybinds() -> void:
	var err = config.load(SAVE_PATH)
	if err == OK and config.has_section_key("Keybinds", "slots"):
		slotted_binds = config.get_value("Keybinds", "slots")
		_sync_inputmap_to_slots()
