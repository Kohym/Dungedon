extends CharacterBody2D

#region vars
#region exported_vars
var isalive = true
@export var cam :Camera2D
@export var base_hp = 50
@export var what_level:int = 0
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

@export var medkit_heal = 35
@export var potionGadd = 20
@export var potionG2add = 20
@export var potionR2works = true

#endregion
var progress_path="user://Dungedon_game.save"

var knockback_dir = Vector2()
var input: Vector2
var speedboost = 0

var debug_hp

@onready var dev_max_hp = base_hp

var isattac = false
var isholster = true
var isuholsteringmove = false
var ispoison = false
var ishealing = false

var willhitwall = false

var max_hp:int = 0
var hp: int = 0
var beat: int =0

var has_eye: bool = false
var has_armor: bool = false
var has_bandage: bool = false
var has_gem: bool = false
var has_neck: bool = false

var lifesteal_en: bool = false

var has_got_keys = false
var keys_moving = false
var has_blue_key = false
var has_green_key = false
var has_red_key = false
var has_universal_key = false

#endregion

func _ready():
	$playersprite/player_wepon_sword.monitorable = false
	$playersprite/player_wepon_sword.monitoring = false
	key_check()
	$playersprite.rotation = look
	loaddata()

#region save andl load
func  loaddata():
	if FileAccess.file_exists(progress_path):
		var file = FileAccess.open(progress_path, FileAccess.READ)
		debug_hp =file.get_var(hp)
		base_hp = file.get_var(max_hp)
		beat = file.get_var(beat)
		has_eye = file.get_var(has_eye)
		has_armor= file.get_var(has_armor)
		has_bandage = file.get_var(has_bandage)
		has_gem = file.get_var(has_gem)
		has_neck = file.get_var(has_neck)
		$playersprite/playerbar.value = debug_hp
		$playersprite/playerbar.max_value = base_hp
		$playerhp.text = str(debug_hp)
		if has_eye == true:
			cam.zoom = Vector2(1.5,1.5)
		if has_armor == true:
			take_A_dmg = take_A_dmg - 7
		if has_bandage == true:
			medkit_heal = medkit_heal + 15
		if has_gem == true:
			lifesteal_en = true
		if has_neck == true:
			take_E_poison_dmg = take_E_poison_dmg-20
	else:
		print("no data player")

func  save():
	hp = $playersprite/playerbar.value
	max_hp = base_hp
	var file = FileAccess.open(progress_path, FileAccess.WRITE)
	hp = $playersprite/playerbar.value
	hp = debug_hp
	max_hp = base_hp
	file.store_var(hp)
	file.store_var(max_hp)
	if what_level > 0:
		beat = what_level +1
		file.store_var(beat)
	else:
		file.store_var(beat) 
	file.store_var(has_eye)
	file.store_var(has_armor)
	file.store_var(has_bandage)
	file.store_var(has_gem)
	file.store_var(has_neck)
	print(beat)
#endregion 

#region upgrades
func check_up(upgrade:String):
	if upgrade == "eye":
		cam.zoom = Vector2(1.5,1.5)
		has_eye = true
	if upgrade == "armor":
		take_A_dmg = take_A_dmg - 7
		has_armor = true
	if upgrade == "bandage":
		medkit_heal = medkit_heal + 15
		has_bandage = true
	if upgrade == "gem":
		lifesteal_en = true
		has_gem = true
	if upgrade == "neck":
		take_E_poison_dmg = take_E_poison_dmg-20
		has_neck = true

func lifesteal():
	if lifesteal_en == true:
		$playersprite/playerbar.value = $playersprite/playerbar.value + 5
	else:
		pass

func buy_upgrade(cost:int):
	debug_hp = debug_hp - int(cost)
	$playersprite/playerbar.value = $playersprite/playerbar.value -int(cost)
	$playerhp.text = str(int($playerhp.text)-int(cost))
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
	if Input.is_action_just_pressed("left_click") and isattac == false and isholster == false and willhitwall == false and lockemove == false:
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
	if isholster== true and isuholsteringmove == false and has_got_keys == false and keys_moving == false and isattac == false:
		isuholsteringmove = true
		setspeed()
		$unholster.play()
		$anim.play("unholster")
	elif isholster== false and isuholsteringmove == false and has_got_keys == false and keys_moving == false and isattac == false:
		isuholsteringmove = true
		setspeed()
		$holster.play()
		$anim.play("holster")

func _on_debug_body_entered(body):
	if body.is_in_group("brick") or body.is_in_group("door"):
		willhitwall = true

func _on_debug_body_exited(body):
	if body.is_in_group("brick") or body.is_in_group("door"):
		willhitwall = false

func attack():
	if isalive == true:
		var rng = RandomNumberGenerator.new()
		var cislo = rng.randi_range(1,2)
		$swing.play()
		if cislo == 1:
			$anim.play("attackk_sword")
		elif  cislo == 2:
			$anim.play("attackk_sword_2")

func get_keys():
	key_check()
	if (has_got_keys == false and keys_moving == false and isholster == true and isuholsteringmove == false and isattac == false):
		keys_moving = true
		$key.play()
		$anim.play("get_key")
	elif  (has_got_keys == true and keys_moving == false and isholster == true and isuholsteringmove == false and isattac == false):
		keys_moving = true
		$key.play()
		$anim.play("unget_key")

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attackk_sword" or anim_name =="attackk_sword_2":
		isattac = false
	elif  anim_name == "get_key":
		has_got_keys = true
		keys_moving = false
	elif anim_name == "unget_key":
		has_got_keys = false
		keys_moving = false
	elif  anim_name == "holster":
		isholster = true
		isuholsteringmove = false
	elif anim_name =="unholster":
		isholster = false
		isuholsteringmove = false
	setspeed()
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
func _physics_process(_delta):
	$playerhp.text = str($playersprite/playerbar.value)
	debug_hp = $playersprite/playerbar.value
	if  ($playersprite/playerbar.value < 0 or $playersprite/playerbar.value == 0):
		$playersprite/playerbar.value = 0
		$playerhp.text = str($playersprite/playerbar.value)
		died()

func _on_playerhurtbox_area_entered(area):
	if area.is_in_group("medkit"):
		ishealing = true
		ispoison = false
		var tween = get_tree().create_tween()
		tween.tween_property($playersprite/playerbar, "value" , $playersprite/playerbar.value + medkit_heal, 0.73)
		if $playersprite/playerbar.value > 500:
			$playersprite/playerbar.value = 500
		if base_hp > 500:
			base_hp = 500
		if  ($playersprite/playerbar.value >= base_hp):
			$playersprite/playerbar.value = base_hp
			$playerhp.text = str($playersprite/playerbar.value)
			ishealing = false
		attspeed = 0.1
	elif area.is_in_group("enemy_wepon_sword"):
		var tween = get_tree().create_tween()
		tween.tween_property($playersprite/playerbar, "value" , $playersprite/playerbar.value - take_A_dmg, 0.4)
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
			ispoison = true
			for n in debug_hp:
				var rng = RandomNumberGenerator.new()
				var timer = rng.randf_range(0.0001, 0.0005)
				if ispoison == false:
					break
				debug_hp = debug_hp - 1
				$playersprite/playerbar.value = debug_hp
				$playerhp.text = str(debug_hp)
				await get_tree().create_timer(timer).timeout
				if  (debug_hp <= 0):
					debug_hp = 0
					$playerhp.text = str(debug_hp)
					died()

func _on_playerhurtbox_body_entered(body):
	if body.is_in_group("spikes"):
		attspeed = 10
		var tween = get_tree().create_tween()
		tween.tween_property($playersprite/playerbar, "value" , $playersprite/playerbar.value - take_E_spike_dmg, 0.2)
		attspeed = 0.1
	elif body.is_in_group("poison"):
		ispoison = true
		attspeed = 30
		for n in take_E_poison_dmg:
			var rng = RandomNumberGenerator.new()
			var timer = rng.randf_range(0.1, 0.7)
			if ishealing == false and ispoison == true:
				if ishealing == true and ispoison == false:
					ispoison = false
					setspeed()
					break
				debug_hp = debug_hp - 1
				$playersprite/playerbar.value = debug_hp
				$playerhp.text = str(debug_hp)
				await get_tree().create_timer(timer).timeout
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
	ispoison = false
	base_hp = base_hp + potionGadd
	$playersprite/playerbar.max_value = base_hp
	if base_hp > 500:
		base_hp = 500

func died():
	var level = $"../"
	level.playerdied()
	Engine.time_scale = 0
	isalive = false
#endregion
