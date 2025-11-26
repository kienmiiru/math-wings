extends Node2D

@export var speed := 200.0
@export var question_text = ""
@export var answer_1_text = ""
@export var answer_2_text = ""
@export var is_answer_top = true
var is_hit = false

func stop():
	speed = 0

func _ready():
	$Answer1.text = answer_1_text
	$Answer2.text = answer_2_text
	$UpperBlocker.disabled = is_answer_top == true
	$LowerBlocker.disabled = is_answer_top != true

func _process(delta):
	pass

func _physics_process(delta):
	position += Vector2.LEFT * speed * delta
