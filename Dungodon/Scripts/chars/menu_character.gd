extends CharacterBody2D

func _ready():
	var rng = RandomNumberGenerator.new()
	var cislo = rng.randf_range(0,360)
	$player_wepon_sword.rotation_degrees = cislo
	var cislo1 = rng.randi_range(0,1)
	var cislo2= rng.randi_range(0,1)
	var cislo3= rng.randi_range(0,1)
	var cislo4= rng.randi_range(0,1)
	var cislo5= rng.randi_range(0,6)
	
	$keys/key_holder/key_blue_sprite.visible = bool(cislo1)
	$keys/key_holder/key_universal_sprite.visible = bool(cislo2)
	$keys/key_holder/key_green_sprite.visible = bool(cislo3)
	$keys/key_holder/key_red_sprite.visible = bool(cislo4)
	$keys/key_holder/key_universal_sprite.frame = cislo5
