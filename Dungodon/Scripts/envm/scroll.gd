extends Control
@onready var level= $"../../../../"
@onready var player = $"../../../"
var debug = false

func _ready():
	await get_tree().create_timer(0.5).timeout
	debug = true

func _on_scroll_button_pressed():
	self.visible = false

func _on_visibility_changed():
	if debug == true:
		level.pausemenu2()
		player.lockmovement()
