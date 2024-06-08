extends Area2D
var rng = RandomNumberGenerator.new()

func _ready():
	var randint = rng.randi_range(1,2)
	if randint == 1:
		$medkit_sprite.play("1")
	elif randint == 2:
		$medkit_sprite.play("2")

func _on_body_entered(body):
	if body.is_in_group("player_body"):
		queue_free()
