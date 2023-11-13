extends Label

signal change_pallet(palletGenerate)

var countdown = 60
var nPallet = 0
var palletGenerate = 2
var palletTimer

var nodeMain

func getCountdown():
	return countdown

# Called when the start timer runs out
func _on_StartCountdown_game_start():
	nodeMain = get_parent().get_parent()
	
	palletTimer = Timer.new()
	add_child(palletTimer)
	palletTimer.wait_time = 1.0
	palletTimer.connect("timeout", self, "_on_Timer_timeout")
	palletTimer.start()
	
	nodeMain.get_node("ClosePalletButton").set_disabled(false)

# Called when the pallet timer runs out
func palletEnded():
	palletTimer = Timer.new()
	add_child(palletTimer)
	palletTimer.wait_time = 1.0
	palletTimer.connect("timeout", self, "_on_Timer_timeout")
	countdown = 60
	
	emit_signal("change_pallet", palletGenerate)
	nodeMain.get_node("ClosePalletButton").rect_position.x = 240 + (384 * (palletGenerate - 1))
	palletGenerate += 1
	rect_position.x = 65 + (386 * nPallet)
	palletTimer.start()

# Timer countdown after each timeout of the timer
func _on_Timer_timeout():
	if (countdown != 1):
		countdown -= 1
		set_text(str(countdown))
	elif(nPallet != 2):
		nPallet += 1
		palletTimer.queue_free()
		palletEnded()
	else:
		var score = nodeMain.get_node("Score").getTotalScore()
		SceneSwitcher.change_scene("res://scenes/GameOver.tscn", {"score": score})


func _on_ClosePalletButton_pressed():
	yield(get_tree().create_timer(0.1), "timeout")
	#nodeMain.get_node("Score").calcBonus()
	countdown = 1
	yield(get_tree().create_timer(0.1), "timeout")
