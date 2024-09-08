extends Control

var save_path = "user://Dungedon_settings.save"

func _ready():
	Engine.time_scale = 1
	load_data()

#region main_menu
func _on_levels_button_pressed():
	$menus/main_menu.visible = false
	$menus/levels_menu.visible = true

func _on_options_button_pressed():
	load_data()
	$menus/main_menu.visible = false
	$menus/options_menu.visible = true
func _on_credits_button_pressed():
	$menus/main_menu.visible = false
	$menus/credits_menu.visible = true

func _on_exit_button_pressed():
	get_tree().quit()
#endregion

#region levels_menu
var whatlevel
func _on_tutorial_button_pressed():
	whatlevel = "tutorial"
func _on_lvl_1_button_pressed():
	whatlevel = 1

func _on_lvl_2_button_pressed():
	whatlevel = 2

func _on_lvl_3_button_pressed():
	whatlevel = 3

func _on_lvl_4_button_pressed():
	whatlevel = 4

func _on_lvl_5_button_pressed():
	whatlevel = 5

func _on_levels_back_button_pressed():
	$menus/levels_menu.visible =false
	$menus/main_menu.visible = true

func _on_levlels_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level_"+str(whatlevel)+".tscn")
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
var option_volume_value = 5
func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db($menus/options_menu/option_volume/volume_slider.value))
	option_volume_value = $menus/options_menu/option_volume/volume_slider.value
#endregion
#region options_general
func _on_options_back_button_pressed():
	$menus/options_menu.visible = false
	$menus/main_menu.visible = true

func _on_options_save_button_pressed():
	save()

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(option_volume_value)
	file.store_var(option_darkmode)
	$Node2D.use_parent_material = option_darkmode
	$menus/options_menu/saved_label.visible = true
	await get_tree().create_timer(0.5).timeout
	$menus/options_menu/saved_label.visible = false

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		option_volume_value = file.get_var(option_volume_value)
		$menus/options_menu/option_volume/volume_slider.value = option_volume_value
		option_darkmode = file.get_var(option_darkmode)
		$menus/options_menu/option_darkmode/darkmode_button.text = str(option_darkmode)
		$Node2D.use_parent_material = option_darkmode
	else:
		print("no data")
#endregion
#endregion

#region credits_menu
func _on_credits_back_button_pressed():
	$menus/main_menu.visible = true
	$menus/credits_menu.visible = false
#endregion

func _on_dev_level_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level_dev.tscn")
