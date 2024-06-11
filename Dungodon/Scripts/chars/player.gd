extends CharacterBody2D

#region vars
#region exported_vars
var isalive = true
@export var base_hp = 100
@export_range(-360, 360, 0.5, ) var look: float

@export_group("speeds")
var SPEED = 400.0
var lockemove = false
@export var ACCEL = 20.0
@export var attspeed = 0.1

@export_group("damage, healing and buffs")
@export var take_A_dmg = 20
@export var take_E_spike_dmg = 10
@export var take_E_poison_dmg = 50

@export var medkit_heal = 70
@export var potionGadd = 20
@export var potionG2add = 20
@export var potionR2works = true
#endregion
var knockback_dir = Vector2()
var input: Vector2
var speedboost = 0

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

var has_got_keys = false
var keys_moving = false
var has_blue_key = false
var has_green_key = false
var has_red_key = false
var has_universal_key = false
#endregion

#region movement
func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input.normalized()

func _process(delta):
	$Label.text = str(SPEED)
	if isalive == true:
		setspeed()
		if lockemove == false:
			$playersprite.rotation = get_angle_to(get_global_mouse_position())
			var playerInput = get_input()
			velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
			move_and_slide()

func _ready():
	$playersprite/player_wepon_sword.monitorable = false
	$playersprite/player_wepon_sword.monitoring = false
	$playersprite/playerbar.value = base_hp
	key_check()
	$playersprite.rotation = look

func lockmovement():
	if lockemove == true:
		lockemove = false
	elif lockemove == false:
		lockemove = true

func setspeed():
	if (isattac == true and isholster == false and isuholsteringmove == false and ispoison == false and has_got_keys == false):
		SPEED = 50
	elif (isattac == false and isholster == true and isuholsteringmove == false and ispoison == false and has_got_keys == false):
		SPEED = 400
	elif (isattac == false and isholster == true and isuholsteringmove == false and ispoison == true and has_got_keys == false):
		SPEED = 200
	elif (isattac == false and isholster == false and isuholsteringmove == false and ispoison == false and has_got_keys == false):
		SPEED = 250
	elif (isattac == false and isholster == false and isuholsteringmove == false and ispoison == true and has_got_keys == false):
		SPEED = 150
	elif (isattac == false and isholster == true and isuholsteringmove == true and ispoison == false and has_got_keys == false):
		SPEED = 350
	elif (isattac == false and isholster == true and isuholsteringmove == true and ispoison == true and has_got_keys == false):
		SPEED = 170
	elif (isattac == false and isholster == false and isuholsteringmove == true and ispoison == false and has_got_keys == false):
		SPEED = 350
	elif (isattac == false and isholster == false and isuholsteringmove == true and ispoison == true and has_got_keys == false):
		SPEED = 170
	elif  (isattac == false and isholster == true and isuholsteringmove == false and ispoison == false and has_got_keys == true):
		SPEED=350
	elif  (isattac == false and isholster == true and isuholsteringmove == false and ispoison == true and has_got_keys == true):
		SPEED=180
	if(speedboost != 0):
		SPEED += potionG2add * speedboost
#endregion

#region equip and use
func  _input(_event):
	if Input.is_action_just_pressed("left_click") and isattac == false and isholster == false and willhitwall == false:
		isattac = true
		setspeed()
		attack()
	elif Input.is_action_just_pressed("sword_unholster"):
		if has_got_keys == true:
			get_keys()
			if has_got_keys ==true:
				await get_tree().create_timer(0.5).timeout
				if has_got_keys ==true:
					await get_tree().create_timer(0.5).timeout
		holster()
	elif  Input.is_action_just_pressed("keys"):
		if isholster == false:
			holster()
			await get_tree().create_timer(0.9).timeout
			if isholster ==false:
				await get_tree().create_timer(0.5).timeout
				if isholster ==false:
					await get_tree().create_timer(0.5).timeout
		get_keys()

func holster():
	if isholster== true and isuholsteringmove == false and has_got_keys == false and keys_moving == false:
		isuholsteringmove = true
		setspeed()
		for n in 90:
			$playersprite/player_wepon_sword_holstered_sprite.rotation_degrees += 0.5
			await get_tree().create_timer(0.000000001).timeout
		$playersprite/player_wepon_sword_holstered_sprite.visible = false
		$playersprite/player_wepon_sword.visible = true
		isholster = false
		isuholsteringmove = false
	elif isholster== false and isuholsteringmove == false and has_got_keys == false and keys_moving == false:
		isuholsteringmove = true
		setspeed()
		$playersprite/player_wepon_sword_holstered_sprite.visible = true
		$playersprite/player_wepon_sword.visible = false
		for n in 90:
			$playersprite/player_wepon_sword_holstered_sprite.rotation_degrees += -0.5
			await get_tree().create_timer(0.000000001).timeout
		isholster = true
		isuholsteringmove = false
	setspeed()

func _on_debug_body_entered(body):
	if body.is_in_group("brick") or body.is_in_group("door"):
		willhitwall = true

func _on_debug_body_exited(body):
	if body.is_in_group("brick") or body.is_in_group("door"):
		willhitwall = false

func attack():
	if isalive == true:
		var timer = attspeed*0.001
		$playersprite/player_wepon_sword.monitorable = true
		for n in 72:
			await get_tree().create_timer(timer).timeout
			$playersprite/player_wepon_sword.rotation_degrees += 5
		$playersprite/player_wepon_sword.monitorable = false
		isattac = false
		setspeed()

func get_keys():
	key_check()
	if (has_got_keys == false and keys_moving == false and isholster == true and isuholsteringmove == false):
		keys_moving = true
		for n in 80:
			$playersprite/keys.rotation_degrees += -0.5
			await get_tree().create_timer(0.000000001).timeout
		has_got_keys = true
		keys_moving = false
		$playersprite/keys/key_pickup_detector.monitorable = true
		$playersprite/keys/key_pickup_detector.monitoring = true
		$playersprite/keys/key_holder.monitorable = true
		$playersprite/keys/key_holder.monitoring = true
	elif  (has_got_keys == true and keys_moving == false and isholster == true and isuholsteringmove == false):
		keys_moving = true
		for n in 80:
			$playersprite/keys.rotation_degrees += 0.5
			await get_tree().create_timer(0.000000001).timeout
		has_got_keys = false
		keys_moving = false
		$playersprite/keys/key_holder.monitorable = false
		$playersprite/keys/key_holder.monitoring = false
		$playersprite/keys/key_pickup_detector.monitorable = false
		$playersprite/keys/key_pickup_detector.monitoring = false

func key_check():
		if  has_blue_key == true:
			$playersprite/keys/key_pickup_detector.remove_from_group("pickup_blue_key")
			$playersprite/keys/key_holder/key_blue_sprite.visible = true
			$playersprite/keys/key_holder.add_to_group("has_blue_key")
		elif has_blue_key == false:
			$playersprite/keys/key_pickup_detector.add_to_group("pickup_blue_key")
			$playersprite/keys/key_holder/key_blue_sprite.visible = false
			$playersprite/keys/key_holder.remove_from_group("has_blue_key")
		if  has_red_key == true:
			$playersprite/keys/key_pickup_detector.remove_from_group("pickup_red_key")
			$playersprite/keys/key_holder/key_red_sprite.visible = true
			$playersprite/keys/key_holder.add_to_group("has_red_key")
		elif has_red_key == false:
			$playersprite/keys/key_pickup_detector.add_to_group("pickup_red_key")
			$playersprite/keys/key_holder/key_red_sprite.visible = false
			$playersprite/keys/key_holder.remove_from_group("has_red_key")
		if  has_green_key == true:
			$playersprite/keys/key_pickup_detector.remove_from_group("pickup_green_key")
			$playersprite/keys/key_holder/key_green_sprite.visible = true
			$playersprite/keys/key_holder.add_to_group("has_green_key")
		elif has_green_key == false:
			$playersprite/keys/key_pickup_detector.add_to_group("pickup_green_key")
			$playersprite/keys/key_holder/key_green_sprite.visible = false
			$playersprite/keys/key_holder.remove_from_group("has_green_key")
		if  has_universal_key == true:
			$playersprite/keys/key_pickup_detector.remove_from_group("pickup_universal_key")
			$playersprite/keys/key_holder/key_universal_sprite.visible = true
			$playersprite/keys/key_holder.add_to_group("has_universal_key")
		elif has_universal_key == false:
			$playersprite/keys/key_pickup_detector.add_to_group("pickup_universal_key")
			$playersprite/keys/key_holder/key_universal_sprite.visible = false
			$playersprite/keys/key_holder.remove_from_group("has_universal_key")
#endregion

#region DMG and pickups
func _on_playerhurtbox_area_entered(area):
	if area.is_in_group("enemy_wepon_sword"):
		new_hp = debug_hp - take_A_dmg
		old_hp = new_hp + take_A_dmg
		for n in take_A_dmg:
			debug_hp = debug_hp - 1
			$playersprite/playerbar.value = debug_hp
			$playerhp.text = str(debug_hp)
			await get_tree().create_timer(0.02).timeout
			if  (debug_hp <= 0):
				debug_hp = 0
				$playerhp.text = str(debug_hp)
				died()
	elif area.is_in_group("medkit"):
		ishealing = true
		ispoison = false
		new_hp = debug_hp + medkit_heal
		old_hp = new_hp - medkit_heal
		for n in medkit_heal:
			debug_hp = debug_hp + 1
			$playersprite/playerbar.value = debug_hp
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
	elif area.is_in_group("potionG2"):
		speedboost += 1
		setspeed()
	elif area.is_in_group("potionR"):
		ispoison = false
	elif area.is_in_group("potionR2"):
		if potionR2works == true:
			new_hp = debug_hp - debug_hp
			old_hp = new_hp + debug_hp
			ispoison = true
			for n in debug_hp:
				if ispoison == false:
					break
				debug_hp = debug_hp - 1
				$playersprite/playerbar.value = debug_hp
				$playerhp.text = str(debug_hp)
				await get_tree().create_timer(0.02).timeout
				if  (debug_hp <= 0):
					debug_hp = 0
					$playerhp.text = str(debug_hp)
					died()

func _on_playerhurtbox_body_entered(body):
	if body.is_in_group("spikes"):
		attspeed = 10
		new_hp = debug_hp - take_E_spike_dmg
		old_hp = new_hp + take_E_spike_dmg
		for n in take_E_spike_dmg:
			debug_hp = debug_hp - 1
			$playersprite/playerbar.value = debug_hp
			$playerhp.text = str(debug_hp)
			await get_tree().create_timer(0.02).timeout
			if  (debug_hp <= 0):
				debug_hp = 0
				$playerhp.text = str(debug_hp)
				
				died()
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
					setspeed()
					break
				debug_hp = debug_hp - 1
				$playersprite/playerbar.value = debug_hp
				$playerhp.text = str(debug_hp)
				await get_tree().create_timer(0.5).timeout
				if  (debug_hp <= 0):
					debug_hp = 0
					$playerhp.text = str(debug_hp)
					ispoison = false
					
					died()
		attspeed = 0.1
		ispoison = false
		setspeed()

func _on_key_pickup_detector_area_entered(area):
	if  area.is_in_group("key_blue"):
		has_blue_key = true
	elif area.is_in_group("key_red"):
		has_red_key = true
	elif area.is_in_group("key_green"):
		has_green_key = true
	elif area.is_in_group("key_universal"):
		has_universal_key = true
	await get_tree().create_timer(0.02).timeout
	key_check()

func _on_key_holder_area_entered(area):
	if area.is_in_group("locked_red"):
		if has_red_key == true:
			has_red_key = false
			await get_tree().create_timer(0.02).timeout
		elif has_universal_key == true:
			has_universal_key = false
			await get_tree().create_timer(0.02).timeout
		key_check()
	elif area.is_in_group("locked_green"):
		if has_green_key == true:
			has_green_key = false
			await get_tree().create_timer(0.02).timeout
		elif has_universal_key == true:
			has_universal_key = false
			await get_tree().create_timer(0.02).timeout
		key_check()
	elif area.is_in_group("locked_blue"):
		if has_blue_key == true:
			has_blue_key = false
			await get_tree().create_timer(0.02).timeout
		elif has_universal_key == true:
			has_universal_key = false
			await get_tree().create_timer(0.02).timeout
		key_check()
#endregion

#region misic
func addhp():
	base_hp = base_hp + potionGadd
	$playerhp.text = str(base_hp)
	$playersprite/playerbar.max_value = base_hp
	$playersprite/playerbar.value =base_hp
	debug_hp = base_hp

func died():
	var level = $"../"
	level.playerdied()
	Engine.time_scale = 0
	isalive = false
#endregion
