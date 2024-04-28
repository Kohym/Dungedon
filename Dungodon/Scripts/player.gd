extends CharacterBody2D

const SPEED = 400.0
const ACCEL = 20.0

var input: Vector2

var take_A_dmg = 20
var take_E_spike_dmg = 15

var base_hp = 100
var old_hp
var med_hp
var new_hp
var debug_hp = base_hp

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
	$playerbar.value = base_hp


func _on_playerhurtbox_area_entered(area):
	if area.is_in_group("enemy_wepon_sword"):
		new_hp = debug_hp - take_A_dmg
		old_hp = new_hp + take_A_dmg
		for n in take_A_dmg:
			debug_hp = debug_hp - 1
			$playerbar.value = debug_hp
			$playerhp.text = str(debug_hp)
			await get_tree().create_timer(0.02).timeout
			if  (debug_hp <= 0):
				debug_hp = 0
				$playerhp.text = str(debug_hp)
				queue_free()

func _on_playerhurtbox_body_entered(body):
	if body.is_in_group("spikes"):
		new_hp = debug_hp - take_E_spike_dmg
		old_hp = new_hp + take_E_spike_dmg
		for n in take_E_spike_dmg:
			debug_hp = debug_hp - 1
			$playerbar.value = debug_hp
			$playerhp.text = str(debug_hp)
			await get_tree().create_timer(0.02).timeout
			if  (debug_hp <= 0):
				debug_hp = 0
				$playerhp.text = str(debug_hp)
				queue_free()
