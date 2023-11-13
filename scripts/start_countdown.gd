extends Label

signal game_start
var countdown = 3
onready var startTimer = get_node("StartTimer")

func _ready():
	text = "3"

func _on_Timer_timeout():
	if(countdown != 1):
		countdown -= 1
		set_text(str(countdown))
	else:
		emit_signal("game_start")
		visible = false
		startTimer.stop()
		print("Game Start")
