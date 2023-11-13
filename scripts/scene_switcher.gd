extends Node

var _params = null

func change_scene(next_scene, params=null):
	_params = params
	get_tree().change_scene(next_scene)

func get_params(name):
	return _params[name]
	
