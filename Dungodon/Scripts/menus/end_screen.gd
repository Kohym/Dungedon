extends Control

func _ready() -> void:
	$anim.play("menu_anim")

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
