extends CharacterBody2D

const SPEED = 400.0
const ACCEL = 20.0

var input: Vector2

var takeDdmg = 5
var takeAdmg = 20
var takeEdmg = 15

var basehp = 100
var oldhp
var medhp
var newhp
var debughp = basehp

func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input.normalized()

func _process(delta):
	look_at(get_global_mouse_position())
	var playerInput = get_input()
	
	velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
	
	move_and_slide()

func _ready():
	$playerbar.value = basehp


func _on_playerdmgdetect_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	newhp = debughp - takeAdmg
	oldhp = newhp + takeAdmg
	for n in takeAdmg:
		debughp = debughp - 1
		$playerbar.value = debughp
		$playerhp.text = str(debughp)
		await get_tree().create_timer(0.02).timeout
		if  (debughp <= 0):
			debughp = 0
			$playerhp.text = str(debughp)
			queue_free()


func _on_playerdmgdetect_body_entered(body):
	if body.is_in_group("test"):
		print("facha")
