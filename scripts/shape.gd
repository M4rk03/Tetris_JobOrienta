extends Node2D
signal placed

const GRID_SIZE = 32
var arrayAreaColliding = []
export var arrayPositionShape = []

var isDroppable = false
export var isPickable = false
var used = 0

var shapeTimer
var camion_callback

var x_min
var x_max

#
func _ready():
	shapeTimer = Timer.new()
	add_child(shapeTimer)
	shapeTimer.connect("timeout", self, "_on_Timer_timeout")
	
func get_nPallet():
	var nPallet = get_parent().get_node("LeftPallet/PalletCountdown").nPallet
	
	match(nPallet):
				0:
					x_min = 192
					x_max = 416
				1:
					x_min = 576
					x_max = 800
				2:
					x_min = 960
					x_max = 1184
	return nPallet

#
func countPoint():
	yield(get_tree().create_timer(0.1), "timeout")
	var insideCount = 0
	var blocks = self.get_children()
	get_nPallet()
	
	for i in range(0, 4):
		var el = blocks[i].global_position
		if(el.y >= 496 && el.y <= 688):
			if(el.x >= x_min && el.x <= x_max):
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
	get_nPallet()
	
	for el in arrayPositionShape:
		for i in range(0, 4):
			var pos = blocks[i].global_position + value
			if pos.x >= x_min && pos.x <= x_max:
				if pos == el || pos.y > 688:
					n += 1
	return n
	
#
func controlCollision():
	if isDroppable:
		var n = collisionShape(Vector2(0,0))
		if n != 0:
			position += Vector2(0,-32)
			controlCollision()
		else:
			setArrayPosition()
			used = 1
			return true
	
#
func dropShape():
	if isDroppable:
		if controlCollision():
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
			pass
		elif(arrayAreaColliding[i].name == "AreaGridElement"):
			isDroppable = true
		elif(arrayAreaColliding[i].name == "PalletArea2D"):
			var nPallet = get_nPallet()
			if arrayAreaColliding[i].get_parent().name == "LeftPallet" && nPallet == 0 || arrayAreaColliding[i].get_parent().name == "CentralPallet" && nPallet == 1 || arrayAreaColliding[i].get_parent().name == "RightPallet" && nPallet == 2:
				dropShape()
		else:
			isDroppable = false

#		
func _process(_delta):
	camion_callback = get_parent().get_node("Camion").callback
	
	if isPickable && !camion_callback:
		checkIfDroppable()
			
		if Input.is_action_just_pressed("rotate"):
			if collisionShape(Vector2(-32,0)) == 0 && collisionShape(Vector2(32,0)) == 0 && collisionShape(Vector2(0,32)) == 0:
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
			else:
				dropShape()
			
		if shapeTimer.is_stopped():
			startShapeTimer()
			
		if self.position.y > 760:
			queue_free()
			get_parent().get_node("Score").totalScore -= 200
			emit_signal("placed")

#
func startShapeTimer():
	shapeTimer.start()

#
func _on_Timer_timeout():
	if isPickable && !camion_callback:
		if collisionShape(Vector2(0,32)) == 0:
			self.position.y += GRID_SIZE
			startShapeTimer()
		else:
			dropShape()
