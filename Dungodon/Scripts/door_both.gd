extends CharacterBody2D

@export var isopen = false
@export var islocked = false
@export var iflocked = "Door is Locked"
func _ready():
	if (isopen == true):
		$door_both_sprite.play("open")
		$door_both_collbox.set_deferred("disabled", true)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player_body"):
		if (islocked == false):
			$door_both_sprite.play("open")
			$door_both_collbox.set_deferred("disabled", true)
			await get_tree().create_timer(2.0).timeout
			$door_both_sprite.play("closed")
			$door_both_collbox.set_deferred("disabled", false)
		if (islocked == true):
			print("locked")
			$door_both_label.text = str(iflocked)
			
