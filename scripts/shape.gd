extends Node2D
signal placed

const GRID_SIZE = 32
var arrayAreaColliding = []
export var arrayPositionShape = []

var isDroppable = false
export var isPickable = false

var shapeTimer


#
func _ready():
	shapeTimer = Timer.new()
	add_child(shapeTimer)
	shapeTimer.connect("timeout", self, "_on_Timer_timeout")

#
func countPoint():
	yield(get_tree().create_timer(0.1), "timeout")
	var insideCount = 0
	var blocks = self.get_children()
	
	if isDroppable:
		for i in range(0, 4):
			var el = blocks[i].global_position
			if(el.y >= 496 && el.y <= 688):
				var nPallet = get_parent().get_node("LeftPallet/PalletCountdown").nPallet
				match(nPallet):
					0:
						if(el.x >= 192 && el.x <= 416):
							insideCount += 1
					1:
						if(el.x >= 576 && el.x <= 800):
							insideCount += 1
					2:
						if(el.x >= 960 && el.x <= 1184):
							insideCount += 1
		get_parent().get_node("Score").calcScore(insideCount)

#
func setArrayPosition():
	var blocks = self.get_children()
	
	for i in range(0, 4):
		arrayPositionShape.append(blocks[i].global_position)

#
func collisionShape(value):
	var blocks = self.get_children()
	var n = 0
	for el in arrayPositionShape:
		for i in range(0, 4):
			var pos = blocks[i].global_position + value
			#if pos == el || (pos.y > 688 && pos.x >= 192) || (pos.y > 688 && pos.x <= 416): 
			if pos == el || pos.y > 688:
				n += 1
	return n
	
#
func controlCollision():
	var n = collisionShape(Vector2(0,0))
	if n != 0:
		position += Vector2(0,-32)
		controlCollision()
	else:
		setArrayPosition()
	
#
func dropShape():
	if isDroppable:
		controlCollision()
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
			if collisionShape(Vector2(0,32)) != 0:
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
			if collisionShape(Vector2(-32,0)) == 0:
				self.position.x -= GRID_SIZE
		if Input.is_action_just_pressed("right_move"):
			if collisionShape(Vector2(32,0)) == 0:
				self.position.x += GRID_SIZE
		if Input.is_action_just_pressed("down_move"):
			if collisionShape(Vector2(0,32)) == 0:
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
