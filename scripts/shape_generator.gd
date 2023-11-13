extends Node2D

var shapes = ["Shape0", "Shape1", "Shape2", "Shape3"]

var shapeDictionary = [
	"O-Shape",
	"I-Shape",
	"S-Shape",
	"L-Shape",
	"J-Shape",
	"T-Shape"
]

var posX = 256
var posY
var valPosY = 160

func generateShape():
	# Pushes backwards every element in the array
	for i in range (3, 0, -1):
		shapes[i] = shapes[i-1]
		shapes[i].position.x += 160
		shapes[i].position.y = posY
		if(i == 3):
			shapes[i].isPickable = true
	
	var chosenShape = shapeDictionary[randi() % shapeDictionary.size()]
	var shape = load("res://scenes/" + chosenShape + ".tscn").instance()
	if chosenShape == "I-Shape":
		posY = valPosY + 16
	else:
		posY = valPosY
	shape.position.x = posX
	shape.position.y = posY
	# Connects generateShape() function to newly created shape
	shape.connect("placed", self, "generateShape")
	get_parent().call_deferred("add_child", shape)
	shapes[0] = shape

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for i in range(0, 4):
		# Generates random shape name
		var chosenShape = shapeDictionary[randi() % shapeDictionary.size()]
		# Instances shape, sets shape position, puts in the array shapes
		var shape = load("res://scenes/" + chosenShape + ".tscn").instance()
		if chosenShape == "I-Shape":
			posY = valPosY + 16
		else:
			posY = valPosY
		
		shape.position.x = posX + (i * 160)
		shape.position.y = posY
		shape.connect("placed", self, "generateShape")
		get_parent().call_deferred("add_child", shape)
		shapes[i] = shape


func _on_StartCountdown_game_start():
	shapes[3].isPickable = true
	
