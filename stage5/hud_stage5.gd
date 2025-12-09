extends CanvasLayer

var target = 0

func _ready():
	update_hp(1.0)
	update_score(0)

func update_question(question):
	$QuestionLabel.text = question

func update_hp(percentage: float):
	$HPBar.value = percentage * 100

func update_score(val: int):
	$ScoreLabel.text = "Score: %d / %d" % [val, target]

func update_coin(val):
	$CoinLabel.text = "Coin: %d" % val
