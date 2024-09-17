extends Area2D
@export var what_upgrade :String
@export var player1: Node2D
var progress_path="user://Dungedon_game.save"

var has_eye:bool = false
var has_armor:bool = false
var has_bandage:bool = false
var has_gem:bool = false
var has_neck:bool = false

func _ready():
	$upgrade_sprite.animation = str(what_upgrade)
	self.add_to_group(what_upgrade)
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
	#hide_or_no()

#func hide_or_no():
	#if what_upgrade == "eye" and has_eye == true:
		#self.visible = false
		#$upgrade_collbox. disabled = true
	#elif what_upgrade == "armor" and has_armor == true:
		#self.visible = false
		#$upgrade_collbox. disabled = true
	#elif what_upgrade == "bandage" and has_bandage == true:
		#self.visible = false
		#$upgrade_collbox. disabled = true
	#elif what_upgrade == "gem" and has_gem == true:
		#self.visible = false
		#$upgrade_collbox. disabled = true
	#elif what_upgrade == "neck" and has_neck == true:
		#self.visible = false
		#$upgrade_collbox. disabled = true

#func _on_body_entered(body):
	#if body.is_in_group == "player_body":
		#var file = FileAccess.open(progress_path, FileAccess.WRITE)
		#if what_upgrade == "eye":
			#has_eye= true
			#file.store_var(has_eye)
			#player1.check_up()
			#player1.save()
			#$upgrade_collbox.disabled = true
			#$upgrade_sprite.visible = false
		#elif what_upgrade == "armor":
			#has_armor = true
			#file.store_var(has_armor)
			#player1.check_up()
			#player1.save()
			#$upgrade_collbox.disabled = true
			#$upgrade_sprite.visible = false
		#elif what_upgrade == "bandage":
			#has_bandage = true
			#file.store_var(has_bandage)
			#player1.check_up()
			#player1.save()
			#$upgrade_collbox.disabled = true
			#$upgrade_sprite.visible = false
		#elif what_upgrade == "gem":
			#has_gem = true
			#file.store_var(has_gem)
			#player1.check_up()
			#player1.save()
			#$upgrade_collbox.disabled = true
			#$upgrade_sprite.visible = false
		#elif what_upgrade == "neck":
			#has_neck= true
			#file.store_var(has_neck)
			#player1.check_up()
			#player1.save()
			#$upgrade_collbox.disabled = true
			#$upgrade_sprite.visible = false
