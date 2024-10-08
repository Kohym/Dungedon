extends CharacterBody2D
@export var isbroken = false

func _ready():
	if isbroken:
		$destructible_wall2_sprite.play("broken")
		$Area2D.monitorable = false
		$Area2D.monitoring = false
		$Area2D/destructible_wall2_collbox.set_deferred("disabled", "false")
		$destructible_wall2_collbox.set_deferred("disabled", "false")

func _on_area_2d_area_entered(area):
	if area.is_in_group("playerweponsword"):
		await get_tree().create_timer(0.5).timeout
		if area.is_in_group("playerweponsword"):
			$destroy.play()
			$destructible_wall1_sprite.play("broken")
			$Area2D.monitorable = false
			$Area2D.monitoring = false
			$Area2D/destructible_wall1_collbox.set_deferred("disabled", "false")
			$destructible_wall1_collbox.set_deferred("disabled", "false")
