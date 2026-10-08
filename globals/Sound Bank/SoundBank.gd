extends Node

#Store sound effects here...
var sfx_dict : Dictionary = {
	"test_sfx" : preload("res://sound/sfx/sfx_example.mp3")
}

#Here is an example:
#"swing_sword": preload("res://audio/sfx/swing.ogg"),
#"jump": preload("res://audio/sfx/jump.ogg"),
#"slide_friction": preload("res://audio/sfx/friction.wav")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func play_sfx(sfx_name : String, spawn_pos : Vector2 = Vector2.ZERO, rand_low_range : float = 0.7, rand_high_range : float = 1.2, max_dist : float = 4096, volume_db : float = 0.0) -> void:
	#Check if sound exists
	if not sfx_dict.has(sfx_name):
		push_error("GameManager: SFX '" + sfx_name + "' not found in dictionary.")
		return
		
	#Create an audio player
	var sfx_player = AudioStreamPlayer2D.new()
	
	#Give it the specific sound from the dictionary and set its position
	sfx_player.stream = sfx_dict[sfx_name]
	sfx_player.global_position = spawn_pos
	sfx_player.volume_db = volume_db
	sfx_player.pitch_scale = randf_range(rand_low_range, rand_high_range) #Change these values for more variation of the sounds
	sfx_player.bus = "SFX"
	sfx_player.max_distance = max_dist
	
	#Add it to the Game, play it, and queue_free when done
	add_child(sfx_player)
	sfx_player.finished.connect(sfx_player.queue_free)
	sfx_player.play()
