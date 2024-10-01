extends Control
@onready var main = $"../../../"
@onready var sec = $"../../"
var save_path = "user://Dungedon_settings.save"
var option_volume_value: int
var option_eff_volume_balue: int
var option_darkmode: bool = false

func  _ready() -> void:
	loaddata()

func  loaddata():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		option_volume_value = file.get_var(option_volume_value)
		option_eff_volume_balue = file.get_var(option_eff_volume_balue)
		option_darkmode = file.get_var(option_darkmode)
	else: 
		print("no setting")
	if option_darkmode == true:
		$background.color=Color(0.235, 0.235, 0.235)
	elif option_darkmode == false:
		$background.color = Color(0.765, 0.765, 0.765)


func _on_pause_resume_pressed():
	main.pausemenu()

func _on_pasue_quit_pressed():
	get_tree().quit()

func _on_pause_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
