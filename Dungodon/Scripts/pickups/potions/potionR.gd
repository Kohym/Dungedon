extends Area2D

var rng = RandomNumberGenerator.new()

func _ready():
	var randidk = rng.randi_range(0,1)
	if (randidk ==1):
		$potionR_sprite.flip_h = true
	else:
		$potionR_sprite.flip_h = false

func _on_body_entered(body):
	if body.is_in_group("player_body"):
		$eff1.play()
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		$potionR_collbox.disabled = true
		$potionR_sprite.rotate(rng.randi_range(0,360))
		var randint = rng.randi_range(1,3)
		if (randint == 1):
			$potionR_sprite.play("broken1")
		elif (randint == 2):
			$potionR_sprite.play("broken2")
		elif (randint == 3):
			$potionR_sprite.play("broken3")
		var randbool = rng.randi_range(0,3)
		if (randbool ==0):
			$potionR_sprite.flip_h = true
		elif (randbool ==2):
			$potionR_sprite.flip_v = true


func _on_eff_1_finished():
	$eff2.play()
