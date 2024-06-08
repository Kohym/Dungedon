extends Control
@onready var main = $"../../../"
@onready var sec = $"../../"

func _on_pause_resume_pressed():
	main.pausemenu()
	sec.lockmovement()

func _on_pasue_quit_pressed():
	get_tree().quit()
