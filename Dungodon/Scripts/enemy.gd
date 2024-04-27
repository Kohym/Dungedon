extends CharacterBody2D


var takeDdmg = 5
var takeAdmg = 20

var basehp = 100
var oldhp
var medhp
var newhp
var debughp = basehp

func _ready():
	$enembar.value = basehp

func _on_enemdmgdetect_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	newhp = debughp - takeAdmg
	oldhp = newhp + takeDdmg
	for n in takeAdmg:
		debughp = debughp - 1
		$enembar.value = debughp
		$enemhp.text = str(debughp)
		await get_tree().create_timer(0.02).timeout
		if  (debughp <= 0):
			debughp = 0
			$enemhp.text = str(debughp)
			queue_free()


func _on_enemwepon_body_entered(body):
	newhp = debughp - takeDdmg
	oldhp = newhp + takeDdmg
	for n in takeDdmg:
		debughp = debughp - 1
		$enembar.value = debughp
		$enemhp.text = str(debughp)
		await get_tree().create_timer(0.1).timeout
		if  (debughp <= 0):
			debughp = 0
			$enemhp.text = str(debughp)
			queue_free()
