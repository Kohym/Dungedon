extends CharacterBody2D
@export_enum("False", "red", "green", "blue", "True") var islocked: String
@export var isopen = false
@export var iflocked = "Locked"
@export var openforsec = 2.0
func _ready():
	$door_both_label1.add_theme_color_override("font_color", Color(0, 0, 0))
	$door_both_label2.add_theme_color_override("font_color", Color(0, 0, 0))
	if (isopen == true):
		$door_both_sprite.play("open")
		$door_both_collbox.set_deferred("disabled", true)
	if islocked == "True" and iflocked != "Locked":
		iflocked = "Lock destroyed"
	if islocked == "red":
		$door_both_label1.add_theme_color_override("font_color", Color(255, 0, 0))
		$door_both_label2.add_theme_color_override("font_color", Color(255, 0, 0))
		$door_both_open_detect1.add_to_group("locked_red")
		$door_both_open_detect2.add_to_group("locked_red")
	elif islocked == "green":
		$door_both_label1.add_theme_color_override("font_color", Color(0, 255, 0))
		$door_both_label2.add_theme_color_override("font_color", Color(0, 255, 0))
		$door_both_open_detect1.add_to_group("locked_green")
		$door_both_open_detect2.add_to_group("locked_green")
	elif islocked == "blue":
		$door_both_label1.add_theme_color_override("font_color", Color(0, 0, 255))
		$door_both_label2.add_theme_color_override("font_color", Color(0, 0, 255))
		$door_both_open_detect1.add_to_group("locked_blue")
		$door_both_open_detect2.add_to_group("locked_blue")

func open():
	$door_both_sprite.play("open")
	$door_both_collbox.set_deferred("disabled", true)
	await get_tree().create_timer(openforsec).timeout
	$door_both_sprite.play("closed")
	$door_both_collbox.set_deferred("disabled", false)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player_body") or body.is_in_group("enemy_body"):
		if (islocked == "False"):
			open()
		if (islocked != "False"):
			$door_both_label1.text = str(iflocked)
			await get_tree().create_timer(2).timeout
			$door_both_label1.text = " "

func _on_door_both_open_detect_2_body_entered(body):
	if body.is_in_group("player_body") or body.is_in_group("enemy_body"):
		if (islocked == "False"):
			open()
		if (islocked != "False"):
			$door_both_label2.text = str(iflocked)
			await get_tree().create_timer(2).timeout
			$door_both_label2.text = " "

func _on_door_both_open_detect_1_area_entered(area):
	if  area.is_in_group("has_"+islocked+"_key") or area.is_in_group("has_universal_key"):
		islocked = "False"
		$door_both_open_detect1.remove_from_group("locked_red")
		$door_both_open_detect2.remove_from_group("locked_red")
		$door_both_open_detect1.remove_from_group("locked_green")
		$door_both_open_detect2.remove_from_group("locked_green")
		$door_both_open_detect1.remove_from_group("locked_blue")
		$door_both_open_detect2.remove_from_group("locked_blue")
		open()

func _on_door_both_open_detect_2_area_entered(area):
	if  area.is_in_group("has_"+islocked+"_key") or area.is_in_group("has_universal_key"):
		islocked = "False"
		$door_both_open_detect1.remove_from_group("locked_red")
		$door_both_open_detect2.remove_from_group("locked_red")
		$door_both_open_detect1.remove_from_group("locked_green")
		$door_both_open_detect2.remove_from_group("locked_green")
		$door_both_open_detect1.remove_from_group("locked_blue")
		$door_both_open_detect2.remove_from_group("locked_blue")
		open()
