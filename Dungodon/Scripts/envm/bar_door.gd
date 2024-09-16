extends CharacterBody2D

@export_enum("eye", "armor", "bandage", "gem", "neck") var what_upgrade :String
@export var price = 10
@export var player1: Node2D
var progress_path="user://Dungedon_game.save"

var has_eye:bool = false
var has_armor:bool = false
var has_bandage:bool = false
var has_gem:bool = false
var has_neck:bool = false

func _ready():
	$bar_door_sprite.play("closed")
	loaddata()

func loaddata():
	if FileAccess.file_exists(progress_path):
		var file = FileAccess.open(progress_path, FileAccess.READ)
		has_eye = file.get_var(has_eye)
		has_armor= file.get_var(has_armor)
		has_bandage = file.get_var(has_bandage)
		has_gem = file.get_var(has_gem)
		has_neck = file.get_var(has_neck)
	else:
		print("no data")
	hide_or_no()

func hide_or_no():
	print(has_armor, has_bandage, has_eye, has_gem, has_neck)
	if what_upgrade == "eye" and has_eye == true:
		$bar_door_sprite.play("open")
		$bar_door_collbox.disabled = true
	elif what_upgrade == "armor" and has_armor == true:
		$bar_door_sprite.play("open")
		$bar_door_collbox.disabled = true
	elif what_upgrade == "bandage" and has_bandage == true:
		$bar_door_sprite.play("open")
		$bar_door_collbox.disabled = true
	elif what_upgrade == "gem" and has_gem == true:
		$bar_door_sprite.play("open")
		$bar_door_collbox.disabled = true
	elif what_upgrade == "neck" and has_neck == true:
		$bar_door_sprite.play("open")
		$bar_door_collbox.disabled = true

func _on_bar_door_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		player1.debug_hp = int(player1.debug_hp) - price
		$bar_door_sprite.play("open")
		$bar_door_collbox.disabled = true
