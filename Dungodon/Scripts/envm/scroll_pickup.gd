extends Area2D
@export var whattoopen: Control
var debug = true
var firs_time_open = false
func _on_body_entered(body):
	if body.is_in_group("player_body") and debug == true:
		if firs_time_open == false:
			firs_time_open == true
			$scroll_texture.play("used")
		debug = false
		whattoopen.visible = true
		self.monitoring = false
		$scroll_collbox.set_deferred("disabled", true)


func _on_body_exited(body):
	if body.is_in_group("player_body"):
		debug = true
