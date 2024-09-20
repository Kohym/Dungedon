extends Area2D
var rng = RandomNumberGenerator.new()
var rng2 = RandomNumberGenerator.new()

func _ready():
	var randint = rng.randi_range(1,2)
	if randint == 1:
		$medkit_sprite.play("1")
	elif randint == 2:
		$medkit_sprite.play("2")

func _on_body_entered(body):
	if body.is_in_group("player_body"):
		$heal.play()
		$medkit_collbox.set_deferred("disabled", true)

func _on_heal_finished():
	$medkit_sprite.play("used")
	$medkit_sprite.rotate(rng2.randi_range(0,360))
