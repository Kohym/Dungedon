extends Area2D
@export var whattoopen: Control
var debug = true
@export var open_only_once:bool = true

func  _ready():
	var rng = RandomNumberGenerator.new()
	var num = rng.randi_range(0,3)
	var num2 = rng.randi_range(0,1)
	if num2 == 0:
		$scroll_texture.animation = "idle"
	elif num2 == 1:
		$scroll_texture.animation = "idle2"
	$scroll_texture.frame = num

func _on_body_entered(body):
	if body.is_in_group("player_body") and debug == true:
		$scroll_texture.play("used")
		$scroll.play()
		debug = false
		whattoopen.visible = true
		if open_only_once == true:
			self.set_deferred("monitoring", false)
			$scroll_collbox.set_deferred("disabled", true)


func _on_body_exited(body):
	if body.is_in_group("player_body"):
		debug = true
