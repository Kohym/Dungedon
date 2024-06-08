extends Area2D
@export var whattoopen: Control
var debug = true
func _on_body_entered(body):
	if body.is_in_group("player_body") and debug == true:
		debug = false
		whattoopen.visible = true


func _on_body_exited(body):
	if body.is_in_group("player_body"):
		debug = true
