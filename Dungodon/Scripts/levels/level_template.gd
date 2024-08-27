extends Node2D
var paused = false
var win = false
var paused_debug = false
@onready var pause_ui = $player/Camera2D/pause_ui
var save_path = "user://settings.save"
var option_volume_value: int
var option_darkmode: bool

func _ready():
	loaddata()

func  loaddata():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		option_volume_value = file.get_var(option_volume_value)
		option_darkmode = file.get_var(option_darkmode)
	else:
		print("no data")
	$tilemaps.use_parent_material = option_darkmode
	$TextureRect.use_parent_material = option_darkmode
	$doors.use_parent_material = option_darkmode

func _process(delta):
	if win == false:
		if Input.is_action_just_pressed("pause"):
			pausemenu()
func pausemenu():
	if win == false:
		if paused == true and paused_debug == false:
			$player/Camera2D/pause_ui.visible = false
			$player.lockmovement()
			Engine.time_scale = 1
			paused= false
		elif paused == false and paused_debug == false:
			$player/Camera2D/pause_ui.show()
			$player.lockmovement()
			Engine.time_scale = 0
			paused = true

func pausemenu2():
	if win == false:
		if paused == true:
			Engine.time_scale = 1
			paused= false
			paused_debug = false
		else:
			Engine.time_scale = 0
			paused_debug = true
			paused = true

func victory():
	win = true
	$player/Camera2D/win_ui.show()
	Engine.time_scale = 0
	paused = true
	$player.lockmovement()

func playerdied():
	$player/Camera2D/loss_ui.show()
	pausemenu2()
