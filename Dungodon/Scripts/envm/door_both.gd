extends CharacterBody2D
@export_enum("False", "red", "green", "blue", "True") var islocked = "False"
@export var isopen = false
@export var openforsec = 2.0
var play1 =false
var play2= false

func _ready():
	if (isopen == true):
		$door_both_sprite.play("open")
		$door_both_collbox.set_deferred("disabled", true)
	if islocked == "True":
		$door_both_sprite.play("destroyed")
		$door_both_open_detect1.monitoring = false
		$door_both_open_detect2.monitoring = false
		$door_both_open_detect1.monitorable = false
		$door_both_open_detect2.monitorable = false
	if islocked != "False":
		$door_both_navlink.enabled = false
	if islocked == "red":
		$door_both_sprite.play("red")
		$door_both_open_detect1.add_to_group("locked_red")
		$door_both_open_detect2.add_to_group("locked_red")
	elif islocked == "green":
		$door_both_sprite.play("green")
		$door_both_open_detect1.add_to_group("locked_green")
		$door_both_open_detect2.add_to_group("locked_green")
	elif islocked == "blue":
		$door_both_sprite.play("blue")
		$door_both_open_detect1.add_to_group("locked_blue")
		$door_both_open_detect2.add_to_group("locked_blue")

func open():
	if play1 == false:
		play1 = true
		$eff1.play()
	$door_both_sprite.play("open")
	$door_both_collbox.set_deferred("disabled", true)
	$door_both_open_detect1.set_deferred("monitoring", false)
	$door_both_open_detect2.set_deferred("monitoring", false)
	await get_tree().create_timer(openforsec).timeout
	if play2 == false:
		play2 = true
		$eff2.play()
	$door_both_sprite.play("closed")
	$door_both_collbox.set_deferred("disabled", false)
	$door_both_open_detect1.monitoring = true
	$door_both_open_detect2.monitoring = true

func _on_area_2d_body_entered(body):
	if body.is_in_group("player_body") or body.is_in_group("enemy_body"):
		if (islocked == "False"):
			open()
		if (islocked != "False"):
			await get_tree().create_timer(2).timeout

func _on_door_both_open_detect_2_body_entered(body):
	if body.is_in_group("player_body") or body.is_in_group("enemy_body"):
		if (islocked == "False"):
			open()

func _on_door_both_open_detect_1_area_entered(area):
	if  area.is_in_group("has_"+islocked+"_key") or area.is_in_group("has_universal_key"):
		islocked = "False"
		$door_both_open_detect1.remove_from_group("locked_red")
		$door_both_open_detect2.remove_from_group("locked_red")
		$door_both_open_detect1.remove_from_group("locked_green")
		$door_both_open_detect2.remove_from_group("locked_green")
		$door_both_open_detect1.remove_from_group("locked_blue")
		$door_both_open_detect2.remove_from_group("locked_blue")
		$door_both_navlink.enabled = true
		open()

func _on_door_both_open_detect_2_area_entered(area):
	if  area.is_in_group("has_"+islocked+"_key") or area.is_in_group("has_universal_key"):
		islocked = "False"
		$door_both_navlink.enabled = true
		$door_both_open_detect1.remove_from_group("locked_red")
		$door_both_open_detect2.remove_from_group("locked_red")
		$door_both_open_detect1.remove_from_group("locked_green")
		$door_both_open_detect2.remove_from_group("locked_green")
		$door_both_open_detect1.remove_from_group("locked_blue")
		$door_both_open_detect2.remove_from_group("locked_blue")
		$door_both_navlink.enabled = true
		open()


func _on_eff_1_finished():
	play1 = false


func _on_eff_2_finished():
	play2 = false
