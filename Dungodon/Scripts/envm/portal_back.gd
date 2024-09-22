extends Area2D
@export var is_tutorial = false
@export var player1: CharacterBody2D

func _ready():
	$portal_back_sprite.animation = "dis"
	$portal_back_sprite_collbox.disabled = true

func enable():
	$portal_back_sprite.animation = "en"
	$portal_back_sprite_collbox.disabled = false
	$ena.play()

func _on_body_entered(body):
	if body.is_in_group("player_body"):
		if is_tutorial == true:
			get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
		elif is_tutorial == false:
			player1.save()
			get_tree().change_scene_to_file("res://Scenes/levels/level_hub.tscn")