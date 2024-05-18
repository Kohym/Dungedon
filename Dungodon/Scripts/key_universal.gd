extends Area2D
var rng = RandomNumberGenerator.new()

func _ready():
	var randidk = rng.randi_range(0,3)
	if (randidk ==1):
		$potionG_sprite.flip_h = true
		$potionG_sprite.flip_v = false
	elif (randidk ==2):
		$potionG_sprite.flip_h = false
		$potionG_sprite.flip_v = true
	elif (randidk ==3):
		$potionG_sprite.flip_h = true
		$potionG_sprite.flip_v = true

func _on_body_entered(body):
	if body.is_in_group("player_body"):
		queue_free()
