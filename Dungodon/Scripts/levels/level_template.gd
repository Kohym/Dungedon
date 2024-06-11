extends Node2D

var paused = false
var win = false
var paused_debug
@onready var pause_ui = $player/Camera2D/pause_ui

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
