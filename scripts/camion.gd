extends Sprite

var callback = false
var go_out = false

func move_camion():
	callback = true
	visible = true
	
func _process(_delta):
	if callback:
		position.x += 1
		get_parent().get_node("LeftPallet/PalletBase").modulate.a -= 0.0025
		
		for x in get_parent().get_node("LeftPallet").get_children():
			if "GridElement" in x.name:
				x.modulate.a -= 0.0025
	
		if position.x >= 150:
			callback = false
			yield(get_tree().create_timer(1), "timeout")
			go_out = true
		
	if go_out:
		position.x -= 1
		
		if position.x <= -300:
			get_parent().get_node("LeftPallet/PalletCountdown").palletEnded()
			go_out = false
		
