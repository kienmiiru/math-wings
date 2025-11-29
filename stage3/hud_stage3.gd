extends CanvasLayer

func _ready():
	update_hp(1.0)
	update_score(0)
	show_question()

func update_question(question):
	$QuestionLabel.text = question

func update_hp(percentage: float):
	print('hp baru')
	$HPBar.value = percentage * 100

func update_score(val: int):
	$ScoreLabel.text = "Score: %d" % val

func show_question():
	$QuestionLabel.visible = true

func hide_question():
	$QuestionLabel.visible = false
