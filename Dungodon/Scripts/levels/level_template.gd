extends Node2D
var paused = false
var win = false
var paused_debug = false
@onready var pause_ui = $player/Camera2D/pause_ui
var save_path = "user://Dungedon_settings.save"
var option_volume_value: int
var option_eff_volume_balue: int
var option_darkmode: bool = false
@export var ishub: bool = false
@export var istutorial:bool = false
var progress_path="user://Dungedon_game.save"

func _ready():
	loaddata()
	var rng = RandomNumberGenerator.new()
	var music = rng.randi_range(1,6)
	if ishub == false and istutorial == false:
		if music == 1:
			$back1.play()
		elif music ==2:
			$back2.play()
		elif  music ==3:
			$back3.play()
		elif music ==4:
			$back4.play()
		elif  music ==5:
			$back5.play()
		elif music ==6:
			$back6.play()


func  loaddata():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		option_volume_value = file.get_var(option_volume_value)
		option_eff_volume_balue = file.get_var(option_eff_volume_balue)
		option_darkmode = file.get_var(option_darkmode)
	$tilemaps.use_parent_material = option_darkmode
	$doors.use_parent_material = option_darkmode
	if option_darkmode == true:
		$background.color=Color(0.235, 0.235, 0.235)
	elif option_darkmode == false:
		$background.color = Color(0.765, 0.765, 0.765)
	if FileAccess.file_exists(progress_path):
		var file = FileAccess.open(progress_path, FileAccess.READ)
		var hp = 50
		var max_hp = 50
		var beat = 1
		var has_eye = false
		var has_armor = false
		var has_bandage = false
		var has_gem = false
		var has_neck = false
		hp = file.get_var(hp)
		max_hp = file.get_var(max_hp)
		beat = file.get_var(beat)
		has_eye = file.get_var(has_eye)
		has_armor= file.get_var(has_armor)
		has_bandage = file.get_var(has_bandage)
		has_gem = file.get_var(has_gem)
		has_neck = file.get_var(has_neck)
		if ishub == true and istutorial == false:
			$ColorRect.color = Color(0, 0, 0)
			$player/Camera2D/scrolls/scroll6/hp_lab.text = str(max_hp) + "/500" 
			$player/Camera2D/scrolls/scroll6/level_lab.text = str(beat) +"/6"
			if has_armor == true:
				$player/Camera2D/scrolls/scroll6/up_armor.modulate = 255
			if has_bandage == true:
				$player/Camera2D/scrolls/scroll6/up_ban.modulate = 255
			if has_eye == true:
				$player/Camera2D/scrolls/scroll6/up_eye.modulate = 255
			if has_gem == true:
				$player/Camera2D/scrolls/scroll6/up_gem.modulate = 255
			if has_neck == true:
				$player/Camera2D/scrolls/scroll6/up_neck.modulate = 255
			if beat == 6 or beat > 6:
				if has_armor == true and has_bandage == true and has_eye == true and has_gem == true and  has_neck == true:
					if max_hp == 500 or max_hp > 500:
						$HubTrack1.stop()
						$HubTrack2.stop()
						$win.visible = true
						$win2.visible = true
						$yay.play()
						$applause.play()
						$win/confeti.play("default")
						$win/confeti2.play("default")
						$win/confeti3.play("default")
						$env/chill_label.visible = false
						$tilemaps/stair.visible = true
						$win/win_area.monitoring = true

func _on_win_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		$anim.play("fade out")
		$Open.play()

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade out":
		if option_darkmode == false:
			get_tree().change_scene_to_file("res://Scenes/menus/end_screen_white.tscn")
		elif option_darkmode == true:
			get_tree().change_scene_to_file("res://Scenes/menus/end_screen_black.tscn")
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://Scenes/levels/level_hub.tscn")

func _process(_delta):
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
	if ishub == false:
		$back1.stop()
		$back2.stop()
		$back3.stop()
	$player/Camera2D/loss_ui.show()
	pausemenu2()
