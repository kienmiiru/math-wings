extends Node

@export var pipe_scene : PackedScene = preload("res://stage1/two_choice_pipe.tscn")
@export var question_generator_res : Resource = preload("res://question_generator.gd")

var score := 0
var spawn_timer := 0.0
var spawn_interval := 1.75 # detik
var pipes = []
var question_generator = QuestionGenerator.new()
var lost = false
var current_pipe

func _ready():
	$HUDStage1.update_score(score)
	spawn_pipe()
	current_pipe = pipes[0]

func _process(delta):
	spawn_timer += delta
	if spawn_timer > spawn_interval and not lost:
		spawn_pipe()
		spawn_timer = 0

	$HUDStage1.update_question(current_pipe.question_text)

	# Hapus pipe yang sudah lewat layar kiri
	for pipe in pipes:
		if pipe.position.x < -100:
			pipes.erase(pipe)
			pipe.queue_free()
	
	if current_pipe.position.x <= $Bird.position.x:
		if not current_pipe.is_hit:
			score += 1
		$HUDStage1.update_score(score)
		current_pipe = pipes[1]

func spawn_pipe():
	var q = question_generator.generate_question()
	var pipe = pipe_scene.instantiate()
	pipe.position = Vector2(700, randi_range(200, 280))
	pipe.question_text = q["question"]
	pipe.answer_1_text = q["answer_1"]
	pipe.answer_2_text = q["answer_2"]
	pipe.is_answer_top = q["is_answer_top"]
	pipe.add_to_group("pipe_collision")
	add_child(pipe)
	pipes.append(pipe)

func _on_bird_collide() -> void:
	get_tree().call_group("pipe_collision", "stop")
	lost = true
