extends Node2D

var player_name
var points = SceneSwitcher.get_params("score")
var file = "res://file_data.json"
var id = 0
var scores

var file_data = {
		"name" : player_name,
		"score" : points
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var scoreValue = get_node("ScoreValue")
	scoreValue.text = "Hai totalizzato " + str(points) + " punti!"
	
	
func save():
	var textBox = get_node("ResultStore/InsertName")
	player_name = textBox.text
	file_data.name = player_name
	print(player_name)
	var file = File.new()
	var path = "res://file_data.json"
	if (file.file_exists(path)):
		file.open(path, File.READ_WRITE)
		scores = parse_json(file.get_as_text())
		id = max_id(scores) + 1
		file.seek_end(-1)
		file.store_string(",\n")
	else:
		file.open(path, File.WRITE)
		file.store_line("{")
	
	file.seek_end()
	file.store_string("\"" + str(id) + "\": ")
	file.store_string(to_json(file_data))
	file.store_string("\n}")
	file.close()

	
func max_id(scores):
	var max_id = 0
	
	for score in scores:
		if int(score) > max_id:
			max_id = int(score)
	
	return max_id


func _on_SendResult_pressed():
	save()
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_LineEdit_text_changed(new_text):
	player_name = str(new_text)
	return player_name
