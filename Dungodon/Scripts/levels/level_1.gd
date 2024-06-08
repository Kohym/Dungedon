extends Node2D

var paused = false
@onready var pause_ui = $player/Camera2D/pause_ui

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pausemenu()
		$player.lockmovement()
		
func pausemenu():
	if paused == true:
		$player/Camera2D/pause_ui.visible = false
		Engine.time_scale = 1
		paused= false
	else:
		$player/Camera2D/pause_ui.show()
		Engine.time_scale = 0
		paused = true

func pausemenu2():
	if paused == true:
		Engine.time_scale = 1
		paused= false
	else:
		Engine.time_scale = 0
		paused = true
