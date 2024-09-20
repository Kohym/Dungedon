extends Node2D
var paused = false
var win = false
var paused_debug = false
@onready var pause_ui = $player/Camera2D/pause_ui
var save_path = "user://Dungedon_settings.save"
var option_volume_value: int
var option_eff_volume_balue: int
var option_darkmode: bool = false

func _ready():
	loaddata()

func  loaddata():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		option_volume_value = file.get_var(option_volume_value)
		option_eff_volume_balue = file.get_var(option_eff_volume_balue)
		option_darkmode = file.get_var(option_darkmode)
	$tilemaps.use_parent_material = option_darkmode
	$background.use_parent_material = option_darkmode
	$doors.use_parent_material = option_darkmode
	AudioServer.set_bus_volume_db(1, linear_to_db(option_volume_value))
	AudioServer.set_bus_volume_db(2, linear_to_db(option_eff_volume_balue))

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
