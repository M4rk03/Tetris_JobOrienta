extends Node2D
signal placed

const GRID_SIZE = 32
var arrayAreaColliding = []

var isDroppable = false
export var isPickable = false

var insideCount = 0

var shapeTimer
var posShape


func _ready():
	shapeTimer = Timer.new()
	add_child(shapeTimer)
	shapeTimer.connect("timeout", self, "_on_Timer_timeout")

func countGridCollisions():
	yield(get_tree().create_timer(0.1), "timeout")
	arrayAreaColliding = []
	arrayAreaColliding = $ShapeArea2D.get_overlapping_areas()
	
	if isDroppable:
		for i in range(arrayAreaColliding.size()):
			if(arrayAreaColliding[i].name == "AreaGridElement"):
				insideCount += 1
		get_parent().get_node("Score").calcScore(insideCount)

func setPositionShape():
	if "O-Shape" in self.name:
		posShape = Vector2(0,0)
	elif "I-Shape" in self.name:
		if self.rotation_degrees == 90 or self.rotation_degrees == 270:
			posShape = Vector2(-16,0)
		else:
			posShape = Vector2(0,-16)
	elif "S-Shape" in self.name:
		posShape = Vector2(-16,0)
	elif "L-Shape" in self.name or "J-Shape" in self.name or "T-Shape" in self.name:
		if self.rotation_degrees == 90 or self.rotation_degrees == 270:
			posShape = Vector2(0,-16)
		else:
			posShape = Vector2(-16,0)
	else:
		posShape = Vector2(0,0)
	
func dropShape():
	if isDroppable:
		position = Vector2(stepify(global_position.x, GRID_SIZE), stepify(global_position.y, GRID_SIZE))
		print(position)
		setPositionShape()
		position += posShape
		print(position)
		isPickable = false
		z_index -= 1
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		emit_signal("placed")
		countGridCollisions()
		
func checkIfDroppable():
	arrayAreaColliding = []
	arrayAreaColliding = $ShapeArea2D.get_overlapping_areas()
	for i in range(arrayAreaColliding.size()):
		if(arrayAreaColliding[i].name == "ShapeArea2D"):
			dropShape()
		elif(arrayAreaColliding[i].name == "AreaGridElement"):
			isDroppable = true
		elif(arrayAreaColliding[i].name == "PalletArea2D"):
			dropShape()
		else:
			isDroppable = false
			
func _process(delta):
	if isPickable:
		checkIfDroppable()
			
		if Input.is_action_just_pressed("rotate"):
			self.rotation_degrees += 90
			if self.rotation_degrees == 360:
				self.rotation_degrees = 0
				
		if Input.is_action_just_pressed("left_move"):
			self.position.x -= 32
		if Input.is_action_just_pressed("right_move"):
			self.position.x += 32
		if Input.is_action_pressed("down_move"):
			self.position.y += 2
			
		if shapeTimer.is_stopped():
			startShapeTimer()

func startShapeTimer():
	shapeTimer.start()

func _on_Timer_timeout():
	if isPickable:
		self.position.y += 16
		startShapeTimer()
