extends Node2D

var file = "res://file_data.json"
var scores

class MyCustomSorter:
	static func sort_descending(a, b):
		return a.score > b.score


# Called when the node enters the scene tree for the first time.
func _ready():
	if load_json(file) == 0:
		var score_box = load("res://scenes/ScoreBox.tscn").instance()
		score_box._insert_data("Ancora nessun punteggio", "")
		$VBoxContainer.add_child(score_box)
	else:
		scores.sort_custom(MyCustomSorter, "sort_descending")
		
		var pos = 0
		
		for score in scores:
			if(pos >= 10):
				break
			else:
				var score_box = load("res://scenes/ScoreBox.tscn").instance()
				score_box._insert_data(score.name, score.score)
				$VBoxContainer.add_child(score_box)
				pos += 1


func load_json(file):
	var f = File.new()
	
	f.open(file, File.READ)
	if f.get_len() == 0:
		return 0
	else:
		scores = parse_json(f.get_as_text()).values()
		f.close()
		return 1


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
