
extends CharacterBody2D

var rng = RandomNumberGenerator.new()

@export_range(0,360,1) var sword_rotation: int
@export_enum("linear", "loop") var islocked: = "linear"

@export var pathfollow : PathFollow2D

var speed = 100

func _ready():
	var randint = rng.randf_range(0.000, 1)
	pathfollow = get_parent()
	pathfollow.progress_ratio = randint
	$enemy_wepon_sword.visible = false

func _physics_process(delta):
	pathfollow.progress += speed* delta
