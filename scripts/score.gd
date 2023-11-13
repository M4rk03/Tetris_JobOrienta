extends Label

var totalScore = 0
var totInside = 0
var palletScore = 0

func getTotalScore():
	return totalScore

func calcScore(inside):
	totInside += inside
	var outside = 4 - inside
	var insideScore = 100 * inside
	var outsideScore = 50 * outside
	totalScore += insideScore - outsideScore
	palletScore += insideScore - outsideScore

func calcMissed():
	var gridEmpty = 64 - totInside
	var malusEmpty = gridEmpty * 50
	if(totalScore > 0):
		if((totalScore - malusEmpty) < 0):
			totalScore = 0
		else:
			totalScore -= malusEmpty
	else:
		totalScore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	text = str(totalScore)

func calcBonus():
	var time = get_parent().get_node("PalletCountdown").getCountdown()
	# Bonus 10 points per second
	var bonus = time * 10
	palletScore += bonus
	totalScore += palletScore

func _on_PalletCountdown_change_pallet(palletGenerate):
	calcMissed()
	palletScore = 0
