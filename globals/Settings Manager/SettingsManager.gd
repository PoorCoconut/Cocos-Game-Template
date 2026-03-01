extends Node

const SETTINGS_FILE = "user://settings.json"

# --- OUR SETTINGS VARIABLES (With Defaults) ---
var master_vol: float = 1.0
var music_vol: float = 1.0
var sfx_vol: float = 1.0
var screen_shake: bool = true

func _ready():
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

func apply_audio_settings():
	# Godot audio uses Decibels (-80 to 0), not percentages (0.0 to 1.0).
	# linear_to_db() perfectly translates your slider percentage into Decibels!
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_vol))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_vol))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_vol))
