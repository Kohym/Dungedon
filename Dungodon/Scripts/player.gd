extends CharacterBody2D

@export var basespeed = 400
var SPEED = 400.0
@export var ACCEL = 20.0

var input: Vector2

@export var take_A_dmg = 20
@export var take_E_spike_dmg = 10
@export var take_E_poison_dmg = 50

@export var base_hp = 100
@export var attspeed = 0.1
@export var medkit_heal = 70



var old_hp
var med_hp
var new_hp
var debug_hp = base_hp

var isattac = false
var isholster = true
var isuholsteringmove = false
var ispoison = false
var ishealing = false

var willhitwall = false

func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input.normalized()

func _process(delta):
	$Label.text = str(SPEED)
	setspeed()
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
		setspeed()
		attack()
	if Input.is_action_just_pressed("sword_unholster"):
		holster()

func setspeed():
	if (isattac == true and isholster == false and isuholsteringmove == false and ispoison == false):
		SPEED = 50
	elif (isattac == false and isholster == true and isuholsteringmove == false and ispoison == false):
		SPEED = 400
	elif (isattac == false and isholster == true and isuholsteringmove == false and ispoison == true):
		SPEED = 200
	elif (isattac == false and isholster == false and isuholsteringmove == false and ispoison == false):
		SPEED = 250
	elif (isattac == false and isholster == false and isuholsteringmove == false and ispoison == true):
		SPEED = 150
	elif (isattac == false and isholster == true and isuholsteringmove == true and ispoison == false):
		SPEED = 350
	elif (isattac == false and isholster == true and isuholsteringmove == true and ispoison == true):
		SPEED = 170
	elif (isattac == false and isholster == false and isuholsteringmove == true and ispoison == false):
		SPEED = 350
	elif (isattac == false and isholster == false and isuholsteringmove == true and ispoison == true):
		SPEED = 170

func holster():
	if isholster== true and isuholsteringmove == false:
		isuholsteringmove = true
		setspeed()
		for n in 150:
			$player_wepon_sword_holstered_sprite.rotation_degrees += 0.3
			await get_tree().create_timer(0.000000001).timeout
		$player_wepon_sword_holstered_sprite.visible = false
		$player_wepon_sword.visible = true
		isholster = false
		isuholsteringmove = false
	else:
		if isholster== false and isuholsteringmove == false:
			isuholsteringmove = true
			setspeed()
			$player_wepon_sword_holstered_sprite.visible = true
			$player_wepon_sword.visible = false
			for n in 225:
				$player_wepon_sword_holstered_sprite.rotation_degrees += -0.2
				await get_tree().create_timer(0.000000001).timeout
			isholster = true
			isuholsteringmove = false

func attack():
	var timer = attspeed*0.001
	$player_wepon_sword.monitorable = true
	for n in 72:
		await get_tree().create_timer(timer).timeout
		$player_wepon_sword.rotation_degrees += 5
	$player_wepon_sword.monitorable = false
	isattac = false
	setspeed()

func addhp():
	base_hp = base_hp + 20
	$playerhp.text = str(base_hp)
	$playerbar.max_value = base_hp
	$playerbar.value =base_hp
	debug_hp = base_hp

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
	elif area.is_in_group("medkit"):
		ishealing = true
		ispoison = false
		new_hp = debug_hp + medkit_heal
		old_hp = new_hp - medkit_heal
		for n in medkit_heal:
			debug_hp = debug_hp + 1
			$playerbar.value = debug_hp
			$playerhp.text = str(debug_hp)
			await get_tree().create_timer(0.02).timeout
			if  (debug_hp >= base_hp):
				debug_hp = base_hp
				$playerhp.text = str(debug_hp)
				ishealing = false
				break
		attspeed = 0.1
	elif area.is_in_group("potionG"):
		ispoison = false
		addhp()

func _on_playerhurtbox_body_entered(body):
	if body.is_in_group("spikes"):
		attspeed = 10
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
	elif body.is_in_group("poison"):
		ispoison = true
		attspeed = 30
		new_hp = debug_hp - take_E_poison_dmg
		old_hp = new_hp + take_E_poison_dmg
		for n in take_E_poison_dmg:
			if ishealing == false and ispoison == true:
				if ishealing == true and ispoison == false:
					ispoison = false
					break
				debug_hp = debug_hp - 1
				$playerbar.value = debug_hp
				$playerhp.text = str(debug_hp)
				await get_tree().create_timer(0.5).timeout
				if  (debug_hp <= 0):
					debug_hp = 0
					$playerhp.text = str(debug_hp)
					ispoison = false
					queue_free()
					
		attspeed = 0.1

func _on_debug_body_entered(body):
	if body.is_in_group("brick"):
		willhitwall = true


func _on_debug_body_exited(body):
	if body.is_in_group("brick"):
		willhitwall = false
