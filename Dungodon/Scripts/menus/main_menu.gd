extends Control

var save_path = "user://settings.save"

func _ready():
	load_data()

#region main_menu
func _on_levels_button_pressed():
	$menus/main_menu.visible = false
	$menus/levels_menu.visible = true

func _on_options_button_pressed():
	load_data()
	$menus/main_menu.visible = false
	$menus/options_menu.visible = true

func _on_exit_button_pressed():
	get_tree().quit()
#endregion

#region levels_menu
var whatlevel: int
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

func _on_lvl_6_button_pressed():
	whatlevel = 6

func _on_levels_back_button_pressed():
	$menus/levels_menu.visible =false
	$menus/main_menu.visible = true

func _on_levlels_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/level_"+str(whatlevel)+".tscn")
#endregion

#region opions_menu
#region options_volume
var option_volume_value = 5
func _on_volume_minus_pressed():
	option_volume_value -= 1
	if  option_volume_value < 0:
		option_volume_value = 0
	elif option_volume_value > 10:
		option_volume_value = 10
	$menus/options_menu/option_volume/volume.text = str(option_volume_value)

func _on_volume_plus_pressed():
	option_volume_value += 1
	if  option_volume_value < 0:
		option_volume_value = 0
	elif option_volume_value > 10:
		option_volume_value = 10
	$menus/options_menu/option_volume/volume.text = str(option_volume_value)

func _on_options_back_button_pressed():
	$menus/options_menu.visible = false
	$menus/main_menu.visible = true

func _on_options_save_button_pressed():
	save()

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(option_volume_value)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		option_volume_value = file.get_var(option_volume_value)
		$menus/options_menu/option_volume/volume.text = str(option_volume_value)
	else:
		print("no data")
#endregion
#endregion
