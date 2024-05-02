extends CharacterBody2D

@export var SPEED = 400.0
@export var ACCEL = 20.0

var input: Vector2

@export var take_A_dmg = 20
@export var take_E_spike_dmg = 10
@export var take_E_poison_dmg = 50

@export var base_hp = 100
@export var attspeed = 0.1
@export var medkit_heal = 70
var ishealing = false
var old_hp
var med_hp
var new_hp
var debug_hp = base_hp
var isattac = false
var isholster = true
var isuholsteringmove = false
var willhitwall = false
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
	$player_wepon_sword.monitorable = false
	$player_wepon_sword.monitoring = false
	$playerbar.value = base_hp

func  _input(_event):
	if Input.is_action_just_pressed("left_click") and isattac == false and isholster == false and willhitwall == false:
		isattac = true
		attack()
	if Input.is_action_just_pressed("sword_unholster"):
		holster()

func holster():
	if isholster== true and isuholsteringmove == false:
		SPEED = SPEED - 100
		isuholsteringmove = true
		for n in 150:
			$player_wepon_sword_holstered_sprite.rotation_degrees += 0.3
			await get_tree().create_timer(0.000000001).timeout
		$player_wepon_sword_holstered_sprite.visible = false
		$player_wepon_sword.visible = true
		isholster = false
		isuholsteringmove = false
		SPEED = SPEED - 100
	else:
		SPEED = SPEED + 100
		if isholster== false and isuholsteringmove == false:
			isuholsteringmove = true
			$player_wepon_sword_holstered_sprite.visible = true
			$player_wepon_sword.visible = false
			for n in 225:
				$player_wepon_sword_holstered_sprite.rotation_degrees += -0.2
				await get_tree().create_timer(0.000000001).timeout
			isholster = true
			isuholsteringmove = false
			SPEED = SPEED + 100

func attack():
	var timer = attspeed*0.001
	$player_wepon_sword.monitorable = true
	for n in 72:
		await get_tree().create_timer(timer).timeout
		$player_wepon_sword.rotation_degrees += 5
	$player_wepon_sword.monitorable = false
	isattac = false

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
	if area.is_in_group("medkit"):
		ishealing = true
		new_hp = debug_hp + medkit_heal
		old_hp = new_hp - medkit_heal
		for n in medkit_heal:
			debug_hp = debug_hp + 1
			$playerbar.value = debug_hp
			$playerhp.text = str(debug_hp)
			await get_tree().create_timer(0.02).timeout
			if  (debug_hp >= 100):
				debug_hp = 100
				$playerhp.text = str(debug_hp)
				ishealing = false
				break
		attspeed = 0.1
		SPEED = SPEED+100

func _on_playerhurtbox_body_entered(body):
	if body.is_in_group("spikes"):
		attspeed = 10
		SPEED = SPEED -150
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
		attspeed = 0.1
		SPEED = SPEED +150
	if body.is_in_group("poison"):
		SPEED = SPEED-100
		attspeed = 30
		new_hp = debug_hp - take_E_poison_dmg
		old_hp = new_hp + take_E_poison_dmg
		for n in take_E_poison_dmg:
			if ishealing == false:
				if ishealing == true:
					break
				debug_hp = debug_hp - 1
				$playerbar.value = debug_hp
				$playerhp.text = str(debug_hp)
				await get_tree().create_timer(0.5).timeout
				if  (debug_hp <= 0):
					debug_hp = 0
					$playerhp.text = str(debug_hp)
					queue_free()
		SPEED = SPEED +100
		attspeed = 0.1

func _on_debug_body_entered(body):
	if body.is_in_group("brick"):
		willhitwall = true


func _on_debug_body_exited(body):
	if body.is_in_group("brick"):
		willhitwall = false
