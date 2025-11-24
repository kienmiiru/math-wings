extends Node2D
@export var speed := 300.0
@export var question_text = ""
@export var answer_1_text = ""
@export var answer_2_text = ""
@export var is_answer_top = true

func stop():
	speed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Answer1.text = answer_1_text
	$Answer2.text = answer_2_text
	$UpperBlocker.disabled = is_answer_top == true
	$LowerBlocker.disabled = is_answer_top != true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	position += Vector2.LEFT * speed * delta
