extends Control
@export var level: Node2D
@export var player: CharacterBody2D
@export var me: Control
var debug = false

func _ready():
	await get_tree().create_timer(0.5).timeout
	debug = true

func _on_scroll_button_pressed():
	me.visible = false

func _on_visibility_changed():
	if debug == true:
		level.pausemenu2()
		player.lockmovement()


