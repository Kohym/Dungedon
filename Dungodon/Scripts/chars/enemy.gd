extends CharacterBody2D
#region Vars
@export var isboss= false
@export var isdead = false
@export_group("NAV")
@export var player1: Node2D
@export var bricks: TileMap
@export var speed = 300
@export_range(-360, 360, 0.5, ) var look: float
@export var detect_radius = 160
@onready var nav_agent := $enemy_navigation as NavigationAgent2D
var isdetecting = false
var no_more_path = false

var dir = 0

@export_group("DMG and HP")
@export var take_A_sword_dmg = 20
@export var take_E_spike_dmg = 10
@export var heal_E_poison_dmg = 15

@export var base_hp = 100

var basespeed


var ischasing = false
var istooclose = false
var isattac = false
var willhitwall = false
var speedmulti
#endregion

#region movement and pathfinding
func _physics_process(delta: float) -> void:
	dir = 0
	raycast_detect()
	attac()
	$enemhp.text = str($enemsprite/enembar.value)
	if  ($enemsprite/enembar.value < 0 or $enemsprite/enembar.value == 0):
		$enemsprite/enembar.value = 0
		$enemhp.text = str($enemsprite/enembar.value)
		died()
	if istooclose == false and isdead == false:
		if ischasing == true or isdetecting == true:
			$enemsprite.rotation = get_angle_to(player1.global_position)
			$enem_att_detect.rotation = get_angle_to(player1.global_position)
		dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed
		velocity = velocity.normalized() * min(velocity.length(), speed)
		if no_more_path == false:
			move_and_slide()
		elif no_more_path == true:
			velocity = dir * 0

func _ready():
	if isboss == true:
		$enemsprite/boss_sprite.visible = true
		speed = speed *1.02
		base_hp = base_hp * 1.5
	basespeed = speed
	$enemsprite/enembar.max_value = base_hp
	$enemsprite/enembar.value = base_hp
	$enemhp.text = str(base_hp)
	$enem_player_detect/enem_player_detect_collbox.shape.radius = detect_radius
	$enemsprite.rotation = look
	$enem_att_detect.rotation = look

func setspeed():
	if isboss == false:
		speedmulti = float($enemsprite/enembar.value) / 100
		speed = float(basespeed) * speedmulti

func makepath():
	nav_agent.target_position = player1.global_position

func _on_enemy_navigation_navigation_finished():
	no_more_path = true

func raycast_detect():
	var ray1 = $enemsprite/enem_raycast1.get_collider()
	var ray2 = $enemsprite/enem_raycast2.get_collider()
	var ray3 =$enemsprite/enem_raycast3.get_collider()
	var ray4 = $enemsprite/enem_raycast1.get_collider()
	var ray5 = $enemsprite/enem_raycast2.get_collider()
	if ray1 == player1 or ray2== player1 or ray3== player1 or ray4== player1 or ray5== player1:
		isdetecting = true
		no_more_path = false
		makepath()
	elif  ray1 ==bricks and ray2==bricks and ray3==bricks and ray4==bricks and ray5==bricks:
		await get_tree().create_timer(1).timeout
		if ray1 ==bricks and ray2==bricks and ray3==bricks and ray4==bricks and ray5==bricks:
			isdetecting = false
		else:
			isdetecting = true

func _on_enem_player_detect_body_entered(body):
	istooclose = false
	if isdead == false:
		$enemsprite.rotation = get_angle_to(player1.global_position)
		$enem_att_detect.rotation = get_angle_to(player1.global_position)
		istooclose = false
		if isdetecting:
			ischasing = true
			no_more_path = false
		makepath()

func _on_enem_player_detect_body_exited(body):
	await get_tree().create_timer(1).timeout
	ischasing = false
	istooclose = false

func _on_enem_att_detect_body_entered(body):
	if body.is_in_group("player_body"):
		istooclose = true

func _on_enem_att_detect_body_exited(body):
	if body.is_in_group("player_body"):
		istooclose = false

func _on_enemy_timer_timeout():
	if ischasing == true or isdetecting == true:
		makepath()
#endregion

#region attack and damage
func attac():
	if isdead == false:
		for i in 8:
			i += 1
			if istooclose == false:
				break
			if isattac == false and willhitwall == false:
				isattac = true
				$enemsprite/enemy_wepon_sword.add_to_group("enemy_wepon_sword")
				await get_tree().create_timer(0.1).timeout
				var rng = RandomNumberGenerator.new()
				var timer = rng.randf_range(0.0001, 0.0005)
				for n in 90:
					$enemsprite/enemy_wepon_sword.add_to_group("enemy_wepon_sword")
					await get_tree().create_timer(timer).timeout
					$enemsprite/enemy_wepon_sword.rotation_degrees += 4
					$enemsprite/enemy_wepon_sword.remove_from_group("enemy_wepon_sword")
				$enemsprite/enemy_wepon_sword.remove_from_group("enemy_wepon_sword")
				isattac = false

func _on_enemhurtbox_area_entered(area):
	if area.is_in_group("playerweponsword"):
		var tween = get_tree().create_tween()
		tween.tween_property($enemsprite/enembar, "value" , $enemsprite/enembar.value - take_A_sword_dmg, 0.4)
	setspeed()

func _on_enemhurtbox_body_entered(body):
	if body.is_in_group("spikes"):
		var tween = get_tree().create_tween()
		tween.tween_property($enemsprite/enembar, "value" , $enemsprite/enembar.value - take_E_spike_dmg, 0.4)
	elif  body.is_in_group("poison"):
		var tween = get_tree().create_tween()
		tween.tween_property($enemsprite/enembar, "value" , $enemsprite/enembar.value + heal_E_poison_dmg, 0.4)
	setspeed()
#endregion

func died():
	isdead = true
	await get_tree().create_timer(0.2).timeout
	$enemhp.visible = false
	$enemsprite/enemy_wepon_sword.visible = false
	if isboss == true:
		pass
	process_mode = PROCESS_MODE_DISABLED
