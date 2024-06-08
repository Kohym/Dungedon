extends Area2D
var rng = RandomNumberGenerator.new()

func _ready():
	var randidk = rng.randi_range(0,3)
	if (randidk ==1):
		$key_blue_sprite.flip_h = true
		$key_blue_sprite.flip_v = false
	elif (randidk ==2):
		$key_blue_sprite.flip_h = false
		$key_blue_sprite.flip_v = true
	elif (randidk ==3):
		$key_blue_sprite.flip_h = true
		$key_blue_sprite.flip_v = true

func _on_area_entered(area):
	if area.is_in_group("pickup_blue_key"):
		queue_free()
