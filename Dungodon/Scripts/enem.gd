extends Area2D

var takeDdmg = 5
var takeAdmg = 20

var basehp = 100
var oldhp
var medhp
var newhp
var debughp = basehp

func _ready():
	$enembar.value = basehp

func _on_body_entered(body):
	
	newhp = debughp - takeDdmg
	oldhp = newhp + takeDdmg
	if  (newhp <= 0):
			newhp = 0
			$enemhp.text = str(newhp)
			queue_free()
	for n in takeDdmg:
		print(n)
		debughp = debughp - 1
		$enembar.value = debughp
		$enemhp.text = str(debughp)
		await get_tree().create_timer(0.1).timeout
		if  (newhp <= 0):
			newhp = 0
			$enemhp.text = str(newhp)
			queue_free()


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	newhp = debughp - takeAdmg
	oldhp = newhp + takeDdmg
	if  (newhp <= 0):
			newhp = 0
			$enemhp.text = str(newhp)
			queue_free()
	for n in takeAdmg:
		print(n)
		debughp = debughp - 1
		$enembar.value = debughp
		$enemhp.text = str(debughp)
		await get_tree().create_timer(0.03).timeout
		if  (newhp <= 0):
			newhp = 0
			$enemhp.text = str(newhp)
			queue_free()
