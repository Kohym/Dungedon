extends Control
@onready var main = $"../../../"
@onready var sec = $"../../"

func _on_pause_resume_pressed():
	main.pausemenu()

func _on_pasue_quit_pressed():
	get_tree().quit()


func _on_pause_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
