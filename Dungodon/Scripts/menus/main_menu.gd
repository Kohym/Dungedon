extends Control

var save_path = "user://Dungedon_settings.save"
var game_save_path = "user://Dungedon_game.txt"
var hp:int = 50
var max_hp:int = 50
var beat:int = 1
var has_eye:bool = false
var has_armor:bool = false
var has_bandage:bool = false
var has_gem:bool = false
var has_neck:bool = false

func _ready():
	Engine.time_scale = 1
	load_data()
	if FileAccess.file_exists(game_save_path) == true:
		$menus/levels_menu/continue_button.disabled = false
	else:
		$menus/levels_menu/continue_button.disabled = true
	var rng = RandomNumberGenerator.new()
	var num = rng.randi_range(0,2)
	if num == 0:
		$background_music.play()
	elif num == 1:
		$background_music2.play()
	elif num==2:
		$background_music3.play()

#region main_menu
func _on_levels_button_pressed():
	$menus/main_menu.visible = false
	$menus/levels_menu.visible = true

func _on_options_button_pressed():
	load_data()
	$menus/main_menu.visible = false
	$menus/options_menu.visible = true
	$swing.volume_db = -10

func _on_credits_button_pressed():
	if option_darkmode == false:
		get_tree().change_scene_to_file("res://Scenes/menus/end_screen_white.tscn")
	elif option_darkmode == true:
		get_tree().change_scene_to_file("res://Scenes/menus/end_screen_black.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
#endregion

#region levels_menu
func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level_tutorial.tscn")

func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level_hub.tscn")

func _on_new_button_pressed():
	$menus/levels_menu.visible = false
	$menus/new_menu.visible = true

func _on_levels_back_button_pressed():
	$menus/levels_menu.visible =false
	$menus/main_menu.visible = true
#endregion

#region new_menu
func _on_new_cancel_pressed():
	$menus/new_menu.visible = false
	$menus/levels_menu.visible = true

func _on_new_confirm_pressed():
	DirAccess.remove_absolute(game_save_path)
	var new_file = FileAccess.open(game_save_path, FileAccess.WRITE)
	hp = 40
	max_hp = 50
	beat=1
	has_eye = false
	has_armor = false
	has_bandage = false
	has_gem = false
	has_neck = false
	new_file.store_var(hp)
	new_file.store_var(max_hp)
	new_file.store_var(beat)
	new_file.store_var(has_eye)
	new_file.store_var(has_armor)
	new_file.store_var(has_bandage)
	new_file.store_var(has_gem)
	new_file.store_var(has_neck)
	get_tree().change_scene_to_file("res://Scenes/levels/level_hub.tscn")

#endregion

#region opions_menu
#region options_darkmode
var option_darkmode = false
func _on_darkmode_button_pressed():
	if option_darkmode == true:
		option_darkmode = false
	elif option_darkmode == false:
		option_darkmode = true
	$menus/options_menu/option_darkmode/darkmode_button.text = str(option_darkmode)
#endregion
#region options_volume

var option_music_volume_value = 0.5
func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db($menus/options_menu/music_slider.value))
	option_music_volume_value = $menus/options_menu/music_slider.value

var option_eff_volume_balue = 0.5
func _on_eff_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db($menus/options_menu/eff_slider.value))
	option_eff_volume_balue = $menus/options_menu/eff_slider.value

func _on_eff_slider_drag_ended(value_changed):
	$swing.play()
#endregion
#region options_general
func _on_options_back_button_pressed():
	$menus/options_menu.visible = false
	$menus/main_menu.visible = true

func _on_options_save_button_pressed():
	save()

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(option_music_volume_value)
	file.store_var(option_eff_volume_balue)
	file.store_var(option_darkmode)
	$Node2D.use_parent_material = option_darkmode
	$menus/options_menu/saved_label.visible = true
	await get_tree().create_timer(0.5).timeout
	$menus/options_menu/saved_label.visible = false

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		option_music_volume_value = file.get_var(option_music_volume_value)
		$menus/options_menu/music_slider.value = option_music_volume_value
		option_eff_volume_balue = file.get_var(option_eff_volume_balue)
		$menus/options_menu/eff_slider.value = option_eff_volume_balue
		option_darkmode = file.get_var(option_darkmode)
		$menus/options_menu/option_darkmode/darkmode_button.text = str(option_darkmode)
		$Node2D.use_parent_material = option_darkmode
	else:
		print("no data menu")
#endregion
#endregion

func _on_dev_level_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level_dev.tscn")
