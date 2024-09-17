extends Area2D

@export var poratal_num:int = 1

var progress_path="user://Dungedon_game.save"

var beat :int
var enabled = false

func _ready():
	loaddata()

func loaddata():
	if FileAccess.file_exists(progress_path):
		var file = FileAccess.open(progress_path, FileAccess.READ)
		var hp = 50
		var max_hp = 50
		beat = 0
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
		print(beat)
		if beat == poratal_num or beat>poratal_num:
			if poratal_num == 1:
				enabled = true
				$poratl_diff.play("1")
		elif beat == poratal_num or beat>poratal_num:
			if poratal_num == 2:
				enabled = true
				$poratl_diff.play("2")
		elif beat == poratal_num or beat>poratal_num:
			if poratal_num == 3:
				enabled = true
				$poratl_diff.play("3")
		elif beat == poratal_num or beat>poratal_num:
			if poratal_num == 4:
				enabled = true
				$poratl_diff.play("4")
		elif beat == poratal_num or beat>poratal_num:
			if poratal_num == 5:
				enabled = true
				$poratl_diff.play("5")
		elif beat == poratal_num or beat>poratal_num:
			if poratal_num == 6:
				enabled = true
				$poratl_diff.play("6")
		else:
			$poratl_diff.visible = false
	else:
		print("no data")


func _on_body_entered(body):
	if body.is_in_group == "player_body" and enabled ==true:
		get_tree().change_scene_to_file("res://Scenes/levels/level_"+str(poratal_num)+".tscn")
