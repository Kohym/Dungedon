extends CharacterBody2D
@export_range(0,360,1) var sword_rotation: int

func _ready():
	$enemy_wepon_sword.rotation_degrees = sword_rotation
