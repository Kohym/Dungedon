
extends CharacterBody2D
@export var isactive = false
@export_range(0,360,1) var sword_rotation: int
@export_enum("linear", "loop") var islocked: = "linear"

@onready var pathfollow = get_node("/root/Node2D/Path2D/menu_patrol")

var speed = 100

func _ready():
	pathfollow = get_parent()
	$enemy_wepon_sword.rotation_degrees = sword_rotation
	if isactive == true:
		pass

func _physics_process(delta):
	pathfollow.progress += speed* delta
