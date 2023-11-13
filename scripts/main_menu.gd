extends Control


func _on_Start_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_Credits_pressed():
	get_tree().change_scene("res://scenes/CreditsPage.tscn")


func _on_BestScore_pressed():
	get_tree().change_scene("res://scenes/BestScores.tscn")
