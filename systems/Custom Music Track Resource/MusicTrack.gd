extends Resource
class_name MusicTrack

##The name of the track
@export var track_name: String = "New Track"

## This array holds the layers (stems).  Index 0 is the base layer. Index 1 is the next layer up, etc.
@export var stems: Array[AudioStream] = []

## Optional: Useful if you want the tracks to sync perfectly when crossfading
@export var bpm: int = 120
