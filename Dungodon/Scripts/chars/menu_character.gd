extends CharacterBody2D
@export_range(0,360) var sword_rotation := 180

func _ready():
	$player_wepon_sword.rotation_degrees = sword_rotation
