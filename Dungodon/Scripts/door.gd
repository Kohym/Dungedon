extends CharacterBody2D
@export_enum("False", "red", "green", "blue", "True") var islocked: String
@export var isopen = false
@export var openforsec = 2.0
func _ready():
	if (isopen == true):
		$door_sprite.play("open")
		$door_collbox.set_deferred("disabled", true)
	if islocked == "True":
		$door_sprite.play("destroyed")
	if islocked == "red":
		$door_sprite.play("red")
		$door_open_detect.add_to_group("locked_red")
	elif islocked == "green":
		$door_sprite.play("green")
		$door_open_detect.add_to_group("locked_green")
	elif islocked == "blue":
		$door_sprite.play("blue")
		$door_open_detect.add_to_group("locked_blue")

func open():
	$door_sprite.play("open")
	$door_collbox.set_deferred("disabled", true)
	await get_tree().create_timer(openforsec).timeout
	$door_sprite.play("closed")
	$door_collbox.set_deferred("disabled", false)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player_body") or body.is_in_group("enemy_body"):
		if (islocked == "False"):
			open()
		if (islocked != "False"):
			await get_tree().create_timer(2).timeout

func _on_door_open_detect_area_entered(area):
	if  area.is_in_group("has_"+islocked+"_key") or area.is_in_group("has_universal_key") and islocked != "False":
		islocked = "False"
		$door_open_detect.remove_from_group("locked_"+islocked)
		open()
