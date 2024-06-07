extends CharacterBody2D
@export var player1: Node2D
@onready var nav_agent := $enemy_navigation as NavigationAgent2D
@export var isboss= false

@export var take_D_dmg = 5
@export var take_A_sword_dmg = 20
@export var take_E_spike_dmg = 10

@export var base_hp = 100
var old_hp
var med_hp
var new_hp
var debug_hp = base_hp

@export var speed = 100
var basespeed

@export var detect_radius = 160
var ischasing = false
var istooclose = false
var isattac = false
var willhitwall = false
var speedmulti

func _physics_process(delta):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	look_at(player1.global_position)
	print(player1.global_position)
	move_and_slide()
	#if ischasing == true and istooclose == false:
		#velocity = dir * speed
		#velocity = velocity * -1
		#look_at(player1.global_position)
		#move_and_slide()

func _ready():
	makepath()
	basespeed = speed
	if isboss == true:
		base_hp = base_hp *1.5
		debug_hp = base_hp
		$boss_sprite.visible = true
	$enembar.max_value = base_hp
	$enemhp.text = str(base_hp)
	$enembar.value = int(base_hp)
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
			$enemy_wepon_sword.add_to_group("enemy_wepon_sword")
			await get_tree().create_timer(0.1).timeout
			var timer = 0.0005
			for n in 120:
				await get_tree().create_timer(timer).timeout
				$enemy_wepon_sword.rotation_degrees += 3
			$enemy_wepon_sword.remove_from_group("enemy_wepon_sword")
			isattac = false

func setspeed():
	if int($enemhp.text) != 100 and isboss == false:
		speedmulti = float(debug_hp) / 100
		speed = float(basespeed) * speedmulti

func _on_enemhurtbox_area_entered(area):
	if area.is_in_group("playerweponsword"):
		new_hp = debug_hp - take_A_sword_dmg
		old_hp = new_hp + take_A_sword_dmg
		for n in take_A_sword_dmg:
			debug_hp = debug_hp - 1
			$enembar.value = debug_hp
			$enemhp.text = str(debug_hp)
			await get_tree().create_timer(0.02).timeout
			if  (debug_hp <= 0):
				debug_hp = 0
				$enemhp.text = str(debug_hp)
				queue_free()
	setspeed()

func _on_enemhurtbox_body_entered(body):
	if body.is_in_group("player_body"):
		new_hp = debug_hp - take_D_dmg
		old_hp = new_hp + take_D_dmg
		for n in take_D_dmg:
			debug_hp = debug_hp - 1
			$enembar.value = debug_hp
			$enemhp.text = str(debug_hp)
			await get_tree().create_timer(0.1).timeout
			if  (debug_hp <= 0):
				debug_hp = 0
				$enemhp.text = str(debug_hp)
				queue_free()
	if body.is_in_group("spikes"):
		base_hp -= 10
		$enembar.value -= 10
		$enemhp.text = str(base_hp - 10)
		if  (debug_hp <= 0):
			debug_hp = 0
			$enemhp.text = str(debug_hp)
			queue_free()
	setspeed()


func _on_enem_player_detect_body_entered(body):
	$enem_player_detect/enem_player_detect_collbox.shape.radius = detect_radius * 2
	ischasing = true


func _on_enem_player_detect_body_exited(body):
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
	makepath()
