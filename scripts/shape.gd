extends Node2D
signal placed

const GRID_SIZE = 32
var arrayAreaColliding = []
export var arrayPositionShape = []

var isDroppable = false
export var isPickable = false

var insideCount = 0

var shapeTimer
var posShape

#
func _ready():
	shapeTimer = Timer.new()
	add_child(shapeTimer)
	shapeTimer.connect("timeout", self, "_on_Timer_timeout")

#
func countPoint():
	yield(get_tree().create_timer(0.1), "timeout")
	
	if isDroppable:
		for el in arrayPositionShape:
			if(el.x >= 192 && el.x <= 416 && el.y >= 496 && el.y <= 688):
				insideCount += 1
		get_parent().get_node("Score").calcScore(insideCount)

#
func setPositionShape():
	position = Vector2(stepify(global_position.x, GRID_SIZE), stepify(global_position.y, GRID_SIZE))
	
	if "O-Shape" in self.name:
		posShape = Vector2(-16,0)
	else:
		posShape = Vector2(0,-16)

#
func setArrayPosition():
	var blocks = self.get_children()
	
	for i in range(0, 4):
		arrayPositionShape.append(blocks[i].global_position)
		print(blocks[i].global_position)

#
func dropShape():
	if isDroppable:
		setPositionShape()
		position += posShape
		setArrayPosition()
		
		var n = 0
		for el in arrayPositionShape:
			if position == el: 
				n += 1
		if n != 0:
			print('combacia')
		
		isPickable = false
		isDroppable = false
		z_index -= 1
		countPoint()
		emit_signal("placed")

#	
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

#		
func _process(_delta):
	if isPickable:
		checkIfDroppable()
			
		if Input.is_action_just_pressed("rotate"):
			self.rotation_degrees += 90
			if self.rotation_degrees == 360:
				self.rotation_degrees = 0
				
		if Input.is_action_just_pressed("left_move"):
			self.position.x -= GRID_SIZE
		if Input.is_action_just_pressed("right_move"):
			self.position.x += GRID_SIZE
		if Input.is_action_just_pressed("down_move"):
			self.position.y += GRID_SIZE
			
		if shapeTimer.is_stopped():
			startShapeTimer()
			
		if self.position.y > 760:
			queue_free()
			get_parent().get_node("Score").palletScore -= 200
			emit_signal("placed")

#
func startShapeTimer():
	shapeTimer.start()

#
func _on_Timer_timeout():
	if isPickable:
		self.position.y += GRID_SIZE
		startShapeTimer()
