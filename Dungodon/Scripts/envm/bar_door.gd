extends CharacterBody2D

@export var what_upgrade :String
@export var price = 10
@export var player1: Node2D
var progress_path="user://Dungedon_game.save"

var has_eye:bool = false
var has_armor:bool = false
var has_bandage:bool = false
var has_gem:bool = false
var has_neck:bool = false

func _ready():
	$Label.text = str(price)
	$bar_door_sprite.play("closed")
	loaddata()

func loaddata():
	if FileAccess.file_exists(progress_path):
		var file = FileAccess.open(progress_path, FileAccess.READ)
		has_eye = bool(file.get_var(has_eye))
		has_armor= bool(file.get_var(has_armor))
		has_bandage = bool(file.get_var(has_bandage))
		has_gem = bool(file.get_var(has_gem))
		has_neck = bool(file.get_var(has_neck))
	else:
		print("no data")
	hide_or_no()
	print(has_gem)
	print(has_neck)
	print(has_bandage)
	print(has_eye)
	print(has_armor)

func hide_or_no():
	if what_upgrade == "eye" and has_eye == true:
		$Label.visible = false
		$bar_door_sprite.play("open")
		$bar_door_collbox.set_deferred("disabled", true)
		$bar_door_area.monitoring = false
	elif what_upgrade == "armor" and has_armor == true:
		$Label.visible = false
		$bar_door_sprite.play("open")
		$bar_door_area.monitoring = false
	elif what_upgrade == "bandage" and has_bandage == true:
		$Label.visible = false
		$bar_door_sprite.play("open")
		$bar_door_collbox.set_deferred("disabled", true)
		$bar_door_area.monitoring = false
	elif what_upgrade == "gem" and has_gem == true:
		$Label.visible = false
		$bar_door_sprite.play("open")
		$bar_door_collbox.set_deferred("disabled", true)
		$bar_door_area.monitoring = false
	elif what_upgrade == "neck" and has_neck == true:
		$Label.visible = false
		$bar_door_sprite.play("open")
		$bar_door_collbox.set_deferred("disabled", true)
		$bar_door_area.monitoring = false

func _on_bar_door_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		player1.debug_hp = int(player1.debug_hp) - int(price)
		$bar_door_sprite.play("open")
		$bar_door_collbox.set_deferred("disabled", true)
