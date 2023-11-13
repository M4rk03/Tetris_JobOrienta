extends Panel


func _insert_data(name, score):
	$ScoreBox/Name.text = str(name)
	$ScoreBox/Score.text = str(score)
