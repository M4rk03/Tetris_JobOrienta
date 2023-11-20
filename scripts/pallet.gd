extends Node2D

#
func _on_StartCountdown_game_start():
	for x in range (0,8):
		for y in range (0,8):
			var inside = load("res://scenes/GridElement.tscn").instance()
			inside.position.x = (32 * x) + 16
			inside.position.y = (32 * y) + 16
			add_child(inside)
			inside.add_to_group("GridElements")

#
func _on_PalletCountdown_change_pallet(nPallet):
	match(nPallet):
		1:
			if(name == "CentralPallet"):
				for grid in get_tree().get_nodes_in_group("GridElements"):
					grid.queue_free()
				_on_StartCountdown_game_start()
		2:
			if(name == "RightPallet"):
				for grid in get_tree().get_nodes_in_group("GridElements"):
					grid.queue_free()
				_on_StartCountdown_game_start()
