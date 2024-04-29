extends CharacterBody2D

@export var iflocked = "Door is Locked"
@export var islocked = false
@onready var door_sprite = $door_sprite
@onready var door_collbox = $door_collbox
func _on_area_2d_body_entered(body):
	if body.is_in_group("player_body"):
		if (islocked == false):
			door_sprite.play("open")
			door_collbox.set_deferred("disabled", true)
		if (islocked == true):
			print("locked")
			$door_label.text = str(iflocked)
			
