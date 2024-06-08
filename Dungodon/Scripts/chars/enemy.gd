extends CharacterBody2D
@export var isboss= false
@export_group("NAV and BOSS")
@export var player1: Node2D
@export var speed = 300
@onready var nav_agent := $enemy_navigation as NavigationAgent2D

var dir = 0
var work =true
var doknockback = false

@export_group("DMG and HP")
@export var take_A_sword_dmg = 20
@export var take_E_spike_dmg = 10
@export var heal_E_poison_dmg = 15

@export var base_hp = 100
var old_hp
var med_hp
var new_hp
var debug_hp = base_hp

var basespeed

@export var detect_radius = 160
var ischasing = false
var istooclose = false
var isattac = false
var willhitwall = false
var speedmulti

func _physics_process(delta: float) -> void:
	dir = 0
	if ischasing == true and istooclose == false and  doknockback == false and work == true:
		$enemsprite.rotation = get_angle_to(player1.global_position)
		$enem_att_detect.rotation = get_angle_to(player1.global_position)
		dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed
		velocity = velocity.normalized() * min(velocity.length(), speed)
		move_and_slide()
	if doknockback == true:
		work = false
		var kn_dir = player1.global_position.direction_to(self.global_position)
		var knockback = kn_dir * 4
		velocity = knockback * 70
		move_and_slide()
		await get_tree().create_timer(0.3).timeout
		#global_position += knockback
		doknockback = false
		await get_tree().create_timer(0.1).timeout
		work = true

func _ready():
	makepath()
	basespeed = speed
	if isboss == true:
		base_hp = base_hp *1.5
		debug_hp = base_hp
		$enemsprite/boss_sprite.visible = true
	$enemsprite/enembar.max_value = base_hp
	$enemhp.text = str(base_hp)
	$enemsprite/enembar.value = int(base_hp)
	$enem_player_detect/enem_player_detect_collbox.shape.radius = detect_radius

func makepath():
	nav_agent.target_position = player1.global_position

func attac():
	for i in 8:
		i += 1
		if istooclose == false:
			break
		if isattac == false and willhitwall == false:
			isattac = true
			$enemsprite/enemy_wepon_sword.add_to_group("enemy_wepon_sword")
			await get_tree().create_timer(0.1).timeout
			var timer = 0.0005
			for n in 120:
				await get_tree().create_timer(timer).timeout
				$enemsprite/enemy_wepon_sword.rotation_degrees += 3
			$enemsprite/enemy_wepon_sword.remove_from_group("enemy_wepon_sword")
			isattac = false

func setspeed():
	if int($enemhp.text) != 100 and isboss == false:
		speedmulti = float(debug_hp) / 100
		speed = float(basespeed) * speedmulti


func _on_enemhurtbox_area_entered(area):
	if area.is_in_group("playerweponsword"):
		new_hp = debug_hp - take_A_sword_dmg
		old_hp = new_hp + take_A_sword_dmg
		doknockback = true
		for n in take_A_sword_dmg:
			debug_hp = debug_hp - 1
			$enemsprite/enembar.value = debug_hp
			$enemhp.text = str(debug_hp)
			await get_tree().create_timer(0.02).timeout
			if  (debug_hp <= 0):
				debug_hp = 0
				$enemhp.text = str(debug_hp)
				queue_free()
	setspeed()

func _on_enemhurtbox_body_entered(body):
	if body.is_in_group("spikes"):
		new_hp = debug_hp - take_E_spike_dmg
		old_hp = new_hp + take_E_spike_dmg
		for n in take_E_spike_dmg:
			debug_hp = debug_hp - 1
			$enemsprite/enembar.value = debug_hp
			$enemhp.text = str(debug_hp)
			await get_tree().create_timer(0.02).timeout
			if  (debug_hp <= 0):
				debug_hp = 0
				$enemhp.text = str(debug_hp)
				queue_free()
	elif  body.is_in_group("poison"):
		base_hp = base_hp + heal_E_poison_dmg
		new_hp = debug_hp + heal_E_poison_dmg
		old_hp = new_hp - heal_E_poison_dmg
		for n in heal_E_poison_dmg:
			debug_hp = debug_hp + 1
			$enemsprite/enembar.value = debug_hp
			$enemhp.text = str(debug_hp)
			await get_tree().create_timer(0.5).timeout
			if  (debug_hp >= base_hp):
				debug_hp = base_hp
				$enemhp.text = str(debug_hp)
				break
	setspeed()


func _on_enem_player_detect_body_entered(body):
	$enem_player_detect/enem_player_detect_collbox.shape.radius = detect_radius * 2
	ischasing = true


func _on_enem_player_detect_body_exited(body):
	await get_tree().create_timer(1).timeout
	$enem_player_detect/enem_player_detect_collbox.shape.radius = detect_radius
	ischasing = false

func _on_enem_att_detect_body_entered(body):
	if body.is_in_group("player_body"):
		istooclose = true
		attac()

func _on_enem_att_detect_body_exited(body):
	if body.is_in_group("player_body"):
		istooclose = false

func _on_enemy_timer_timeout():
	if ischasing == true:
		makepath()
