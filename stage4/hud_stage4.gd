extends CanvasLayer

func _ready():
	update_hp(1.0)
	update_score(0)
	show_question()

func update_question(question):
	$QuestionLabel.text = question

func update_hp(percentage: float):
	$HPBar.value = percentage * 100

func update_score(val: int):
	$ScoreLabel.text = "Score: %d" % val

func show_question():
	$QuestionLabel.visible = true

func hide_question():
	$QuestionLabel.visible = false

func set_answers(a, b, c):
	$Answers/Answer1.text = a
	$Answers/Answer2.text = b
	$Answers/Answer3.text = c

func hide_answers():
	$Answers/Answer1.hide()
	$Answers/Answer2.hide()
	$Answers/Answer3.hide()

func show_answers():
	$Answers/Answer1.show()
	$Answers/Answer2.show()
	$Answers/Answer3.show()
