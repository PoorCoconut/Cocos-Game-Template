extends Node2D


func _on_play_sfx_pressed() -> void:
	SoundBank.play_sfx("test_sfx", Vector2i(79, 31))
	print("playing sfx")
	pass # Replace with function body.


func _on_play_music_1_pressed() -> void:
	MusicManager.change_music("music1", 0.5)
	print("playing music1")
	pass # Replace with function body.


func _on_play_music_2_pressed() -> void:
	MusicManager.change_music("music2", 0.5)
	print("playing music2")
	pass # Replace with function body.


func _on_stop_music_pressed() -> void:
	MusicManager.stop_music()
	print("music stopped")
	pass # Replace with function body.

func _on_threat_increase_pressed() -> void:
	if MusicManager.current_intensity <= 1.0:
		if MusicManager.current_intensity == 1.0: #You don't really need this check since MusicManager.set_intensity() already handles it
			print("Music Manager's intensity is already max ", MusicManager.current_intensity)
			return
		MusicManager.set_intensity(MusicManager.current_intensity + 0.1, 0.5)
		print("intensity increased ", MusicManager.current_intensity)
	pass # Replace with function body.

func _on_threat_decrease_pressed() -> void:
	if MusicManager.current_intensity >= 0.0:
		if MusicManager.current_intensity == 0.0:
			print("Music Manager's intensity is already minimum ", MusicManager.current_intensity)
			return
		MusicManager.set_intensity(MusicManager.current_intensity - 0.1, 0.5)
		print("intensity decreased ", MusicManager.current_intensity)
	pass # Replace with function body.
