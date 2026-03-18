extends Camera2D

enum CameraMode { 
	##The Camera is fixed in a room. When the target moves out of the room, it moves 1 "room" towards the target's direction.
	ROOM_BASED , 
	##The Camera is fixed to the target. If your room has a CameraLimitZoneCompnent, the camera will automatically stop following when it reaches its limit.
	ENTITY_ATTACHED }
##Camera Mode Options
@export var camera_mode: CameraMode = CameraMode.ENTITY_ATTACHED


@export var target : CharacterBody2D
@export var following : bool = true

var cameraShakeNoise : FastNoiseLite

var viewport_width : float
var viewport_height : float

func _ready() -> void:
	viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	cameraShakeNoise = FastNoiseLite.new()
	
	if camera_mode == CameraMode.ROOM_BASED:
		anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	else:
		anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	
	if target:
		following = true
		_update_camera_position()

func _process(_delta: float) -> void:
	if following and target != null:
		_update_camera_position()

func _update_camera_position() -> void:
	if camera_mode == CameraMode.ROOM_BASED:
		moveCameraToEntity(target.global_position)
	else:
		global_position = target.global_position

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

func apply_room_limits(left: int, right: int, top: int, bottom: int) -> void:
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom
