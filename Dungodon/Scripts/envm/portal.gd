extends Area2D

@export var poratal_num = 1

var progress_path="user://Dungedon_game.save"

var beat = 0
var enabled = false

func _ready():
	loaddata()

func loaddata():
	if FileAccess.file_exists(progress_path):
		var file = FileAccess.open(progress_path, FileAccess.READ)
		beat = file.get_var(beat)
		if beat == poratal_num or beat>poratal_num:
			enabled = true
			$poratl_diff.play(str(poratal_num))
		else:
			$poratl_diff.visible = false
	else:
		print("no data")


func _on_body_entered(body):
	get_tree().change_scene_to_file("res://Scenes/levels/level_"+poratal_num+".tscn")
