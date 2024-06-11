extends CharacterBody2D
@export_enum("False", "red", "green", "blue", "True") var islocked = "False"
@export var isopen = false
@export var openforsec = 2.0
func _ready():
	if (isopen == true):
		$door_sprite.play("open")
		$door_collbox.set_deferred("disabled", true)
	if islocked == "True":
		$door_sprite.play("destroyed")
	if islocked != "False":
		$door_navlink.enabled = false
	if islocked == "red":
		$door_sprite.play("red")
		$door_open_detect.add_to_group("locked_red")
	elif islocked == "green":
		$door_sprite.play("green")
		$door_open_detect.add_to_group("locked_green")
	elif islocked == "blue":
		$door_sprite.play("blue")
		$door_open_detect.add_to_group("locked_blue")
	if islocked != "False":
		$door_navlink.enabled = false


func open():
	$door_sprite.play("open")
	$door_navlink.bidirectional = true
	$door_collbox.set_deferred("disabled", true)
	await get_tree().create_timer(openforsec).timeout
	$door_sprite.play("closed")
	$door_navlink.bidirectional = false
	$door_collbox.set_deferred("disabled", false)
	
var isin

func _on_area_2d_body_entered(body):
	if body.is_in_group("player_body") or body.is_in_group("enemy_body"):
		isin = true
		if (islocked == "False"):
			open()
		if (islocked != "False"):
			pass
		await get_tree().create_timer(openforsec).timeout
		if isin == true:
			$door_navlink.start_position = Vector2(0, 50)
func _on_door_open_detect_body_exited(body):
	if body.is_in_group("player_body") or body.is_in_group("enemy_body"):
		isin = false

func _on_door_open_detect_area_entered(area):
	if  area.is_in_group("has_"+islocked+"_key") or area.is_in_group("has_universal_key") and islocked != "False":
		if islocked != "true":
			islocked = "False"
			$door_open_detect.remove_from_group("locked_"+islocked)
			$door_navlink.enabled = true
			open()


# Replace with function body.
