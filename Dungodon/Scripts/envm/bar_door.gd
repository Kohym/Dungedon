extends CharacterBody2D

@export var what_upgrade :String
@export var price = 10
@export var player1: Node2D
var progress_path="user://Dungedon_game.txt"

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
		var hp = 50
		var max_hp = 50
		var beat = 0
		has_eye = false
		has_armor = false
		has_bandage = false
		has_gem = false
		has_neck = false
		hp = file.get_var(hp)
		max_hp = file.get_var(max_hp)
		beat = file.get_var(beat)
		has_eye = file.get_var(has_eye)
		has_armor= file.get_var(has_armor)
		has_bandage = file.get_var(has_bandage)
		has_gem = file.get_var(has_gem)
		has_neck = file.get_var(has_neck)
	else:
		print("no data bar door")
	open_or_no()

func open_or_no():
	if what_upgrade == "eye" and has_eye == true:
		$Label.visible = false
		$bar_door_sprite.play("open")
		$bar_door_collbox.set_deferred("disabled", true)
		$bar_door_area.monitoring = false
	if what_upgrade == "armor" and has_armor == true:
		$Label.visible = false
		$bar_door_sprite.play("open")
		$bar_door_area.monitoring = false
	if what_upgrade == "bandage" and has_bandage == true:
		$Label.visible = false
		$bar_door_sprite.play("open")
		$bar_door_collbox.set_deferred("disabled", true)
		$bar_door_area.monitoring = false
	if what_upgrade == "gem" and has_gem == true:
		$Label.visible = false
		$bar_door_sprite.play("open")
		$bar_door_collbox.set_deferred("disabled", true)
		$bar_door_area.monitoring = false
	if what_upgrade == "neck" and has_neck == true:
		$Label.visible = false
		$bar_door_sprite.play("open")
		$bar_door_collbox.set_deferred("disabled", true)
		$bar_door_area.monitoring = false

func _on_bar_door_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_body"):
		player1.buy_upgrade(price)
		$bar_door_sprite.play("open")
		$bar_door_collbox.set_deferred("disabled", true)
		$Label.visible = false
		$bar_door_area.monitorable = false
		$bar_door_area.monitoring = false
		$bar_door_area/bar_door_detectbox.set_deferred("disabled", true)
