extends CanvasLayer

var target = 0
@onready var earn_coin_sfx = preload("res://assets/sound/Character earn coin.mp3")

func _ready():
	update_hp(1.0)
	update_score(0)
	AudioPlayer.play_music_normal()

func update_question(question):
	$QuestionLabel.text = question

func update_hp(percentage: float):
	$HPBar.value = percentage * 100

func update_score(val: int):
	$ScoreLabel.text = "Score: %d / %d" % [val, target]

func update_coin(val):
	AudioPlayer.play_FX(earn_coin_sfx)
	$CoinLabel.text = "Coin: %d" % val
