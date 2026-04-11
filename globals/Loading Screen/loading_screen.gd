extends CanvasLayer

@onready var progress_bar = $LoadingBar
var target_scene_path : String = ""

func _ready():
	hide()
	set_process(false) # Turn off _process so it isn't constantly running in the background
	progress_bar.value = 0.0

# Call this function when you want to load a level
func load_level(path: String):
	target_scene_path = path
	show() # Make the loading screen visible
	
	# Ask Godot's background thread to start building the scene
	ResourceLoader.load_threaded_request(target_scene_path)
	
	# Turn on _process so we can monitor the progress bar
	set_process(true)

func _process(_delta):
	##LOADING SCREEN
	var progress_array = [] #pass an empty array to fill it with progress number
	var status = ResourceLoader.load_threaded_get_status(target_scene_path, progress_array) # Ask the ResourceLoader what the current status is
	
	# progress_array[0] returns a decimal between 0.0 and 1.0. 
	# Multiply by 100 to get a normal percentage for the ProgressBar
	if progress_array.size() > 0:
		progress_bar.value = progress_array[0] * 100
	
	if status == ResourceLoader.THREAD_LOAD_LOADED: # Check if the background thread has finished building the scene
		set_process(false)
		#Grab the fully built scene from the background thread
		var new_scene = ResourceLoader.load_threaded_get(target_scene_path)
		#Swap scenes from X to Y
		get_tree().change_scene_to_packed(new_scene)
		
		#Hide loading screen
		hide()
		await get_tree().process_frame
		await get_tree().process_frame
		
		await ScreenTransition.trans_out().finished
		ScreenTransition.reset()
	
	# Failsafe in case the file path is wrong
	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		print("ERROR: Could not load the level! File path is nonexistent")
		hide()
		set_process(false)
