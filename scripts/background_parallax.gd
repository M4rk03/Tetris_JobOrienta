extends ParallaxBackground

#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$ParallaxLayer1.motion_offset.x += -10 * delta
	$ParallaxLayer2.motion_offset.x += -15 * delta
	$ParallaxLayer3.motion_offset.x += -20 * delta
	$ParallaxLayer4.motion_offset.x += -25 * delta
	$ParallaxLayer5.motion_offset.x += -40 * delta
