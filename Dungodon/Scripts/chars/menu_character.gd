extends CharacterBody2D

func _ready():
	var rng = RandomNumberGenerator.new()
	var cislo = rng.randf_range(0,360)
	$player_wepon_sword.rotation_degrees = cislo
