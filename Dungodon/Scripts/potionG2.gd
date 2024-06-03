extends Area2D

var rng = RandomNumberGenerator.new()

func _ready():
	var randidk = rng.randi_range(0,1)
	if (randidk ==1):
		$potionG2_sprite.flip_h = true
	else:
		$potionG2_sprite.flip_h = false

func _on_body_entered(body):
	if body.is_in_group("player_body"):
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		$potionG2_collbox.disabled = true
		$potionG2_sprite.rotate(rng.randi_range(0,360))
		var randint = rng.randi_range(1,3)
		print(randint)
		if (randint == 1):
			$potionG2_sprite.play("broken1")
		elif (randint == 2):
			$potionG2_sprite.play("broken2")
		elif (randint == 3):
			$potionG2_sprite.play("broken3")
		var randbool = rng.randi_range(0,3)
		if (randbool ==0):
			$potionG2_sprite.flip_h = true
		elif (randbool ==2):
			$potionG2_sprite.flip_v = true
