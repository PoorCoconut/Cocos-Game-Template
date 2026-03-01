extends Node
@onready var MUSIC : AudioStreamPlayer = %Music
var music_tween : Tween
var current_target_volume : float = 0.0

func _process(_delta: float) -> void:
	#var desired_volume = -10.0
	#if GameManager.CURRENT_PLAYER_STATE in ["charge", "fall", "stunfall", "menu"]:
		#desired_volume = 0.0
	## If our desired volume changed this frame, trigger the fade!
	#if current_target_volume != desired_volume:
		#current_target_volume = desired_volume
		#fade_music(desired_volume)
		pass

#func fade_music(target_vol: float):
	## Kill the old tween if it's currently fading
	#if music_tween and music_tween.is_valid():
		#music_tween.kill()
	#music_tween = create_tween()
	#
	## Tween to whatever the new target is over 1 second
	#music_tween.tween_property(MUSIC, "volume_db", target_vol, 1.0)
