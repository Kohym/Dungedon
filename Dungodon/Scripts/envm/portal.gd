extends Area2D

@export var poratal_num:int
@export var player: CharacterBody2D
@export var anim:AnimationPlayer
var progress_path="user://Dungedon_game.txt"

var beat :int
var enabled = false

func _ready():
	loaddata()

func loaddata():
	if FileAccess.file_exists(progress_path):
		var file = FileAccess.open(progress_path, FileAccess.READ)
		var hp = 50
		var max_hp = 50
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
	else:
		print("no data portal")
	if beat == poratal_num or beat>poratal_num:
				enabled = true
				$poratl_diff.play(str(poratal_num))
	else:
			$poratl_diff.visible = false


func _on_body_entered(body):
	if body.is_in_group("player_body") and enabled ==true:
		if poratal_num == 1:
			anim.play("fade out_1")
		elif poratal_num == 2:
			anim.play("fade out_2")wa
		elif poratal_num == 3:
			anim.play("fade out_3")
		elif poratal_num == 4:
			anim.play("fade out_4")
		elif poratal_num == 5:
			anim.play("fade out_5")
		elif poratal_num == 6:
			anim.play("fade out_6")

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade out_1":
		player.save()
		get_tree().change_scene_to_file("res://Scenes/levels/level_1.tscn")
	elif anim_name == "fade out_2":
		player.save()
		get_tree().change_scene_to_file("res://Scenes/levels/level_2.tscn")
	elif anim_name == "fade out_3":
		player.save()
		get_tree().change_scene_to_file("res://Scenes/levels/level_3.tscn")
	elif anim_name == "fade out_4":
		player.save()
		get_tree().change_scene_to_file("res://Scenes/levels/level_4.tscn")
	elif anim_name == "fade out_5":
		player.save()
		get_tree().change_scene_to_file("res://Scenes/levels/level_5.tscn")
	elif anim_name == "fade out_6":
		player.save()
		get_tree().change_scene_to_file("res://Scenes/levels/level_6.tscn")
