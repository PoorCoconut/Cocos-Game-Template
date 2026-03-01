extends Camera2D

@export var target : CharacterBody2D
@export var following : bool = true

var cameraShakeNoise : FastNoiseLite

# Cache these variables so we don't ask ProjectSettings every frame!
var viewport_width : float
var viewport_height : float

func _ready() -> void:
	viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	cameraShakeNoise = FastNoiseLite.new()
	
	if target:
		following = true
		# We use our new function to snap it to the right room immediately
		moveCameraToEntity(target.global_position)

func _process(_delta: float) -> void:
	if following and target != null:
		# NOTE: If you are making a room-based game (like Zelda/Metroid), 
		# you should call moveCameraToEntity() here instead of follow_target()
		follow_target()
		#moveCameraToEntity(target.global_position)

func follow_target():
	if target:
		# Because the camera is Top-Left, we MUST subtract half the screen width/height
		# to keep the player perfectly in the center of the screen.
		global_position.x = target.global_position.x - (viewport_width / 2.0)
		global_position.y = target.global_position.y - (viewport_height / 2.0)

func moveCameraToEntity(entity_global_pos : Vector2):
	var grid_x = floor(entity_global_pos.x / viewport_width)
	var grid_y = floor(entity_global_pos.y / viewport_height)
	
	global_position.x = grid_x * viewport_width
	global_position.y = grid_y * viewport_height

func startCameraShake(intensity:float):
	var time = Time.get_ticks_msec()
	offset.x = cameraShakeNoise.get_noise_1d(time) * intensity
	offset.y = cameraShakeNoise.get_noise_1d(time + 10000) * intensity

func resetCameraOffset():
	offset.x = 0
	offset.y = 0
