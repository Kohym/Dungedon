extends CharacterBody2D
@export_enum("False", "red", "green", "blue", "True") var islocked: String
@export var isopen = false
@export var iflocked = "Locked"
@export var openforsec = 2.0
func _ready():
	$door_label.add_theme_color_override("font_color", Color(0, 0, 0))
	if (isopen == true):
		$door_sprite.play("open")
		$door_collbox.set_deferred("disabled", true)
	if islocked == "True" and iflocked != "Locked":
		iflocked = "Lock destroyed"
	if islocked == "red":
		$door_label1.add_theme_color_override("font_color", Color(255, 0, 0))
		$door_open_detect.add_to_group("locked_red")
	elif islocked == "green":
		$door_label1.add_theme_color_override("font_color", Color(0, 255, 0))
		$door_open_detect.add_to_group("locked_green")
	elif islocked == "blue":
		$door_label1.add_theme_color_override("font_color", Color(0, 0, 255))
		$door_open_detect.add_to_group("locked_blue")

func open():
	$door_sprite.play("open")
	$door_collbox.set_deferred("disabled", true)
	await get_tree().create_timer(openforsec).timeout
	$door_sprite.play("closed")
	$door_collbox.set_deferred("disabled", false)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player_body"):
		if (islocked == "False"):
			open()
		if (islocked != "False"):
			$door_label.text = str(iflocked)
			await get_tree().create_timer(2).timeout
			$door_label.text = " "

func _on_door_open_detect_area_entered(area):
	if  area.is_in_group("has_"+islocked+"_key") or area.is_in_group("has_universal_key") and islocked != "False":
		islocked = "False"
		$door_open_detect.remove_from_group("locked_"+islocked)
		open()
