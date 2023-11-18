extends Sprite

var callback = false
var go_out = false

var Pallet
var move
var loading

#
func move_camion(nPallet):
	callback = true
	visible = true
	
	match(nPallet):
		1:
			Pallet = get_parent().get_node("LeftPallet")
			move = 80
			loading = 0.0026
		2:
			Pallet = get_parent().get_node("CentralPallet")
			move = 464
			loading = 0.0013
		3:
			Pallet = get_parent().get_node("RightPallet")
			move = 848
			loading = 0.0009

#
func _process(_delta):
	if callback:
		position.x += 1
		Pallet.get_child(0).modulate.a -= loading
		
		for x in Pallet.get_children():
			if "GridElement" in x.name:
				x.modulate.a -= loading
				
		for s in get_parent().get_children():
			if "Shape" in s.name && s.used == 1:
				s.modulate.a -= loading
	
		if position.x >= move:
			callback = false
			yield(get_tree().create_timer(1), "timeout")
			go_out = true
		
	if go_out:
		position.x -= 1
		
		if position.x <= -300:
			get_parent().get_node("LeftPallet/PalletCountdown").palletEnded()
			go_out = false
		
