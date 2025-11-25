extends Node

@export var pipe_scene : PackedScene = preload("res://two_choice_pipe.tscn")
@export var question_generator_res : Resource = preload("res://question_generator.gd")

var score := 0
var spawn_timer := 0.0
var spawn_interval := 1.75 # detik
var pipes = []
var question_generator = QuestionGenerator.new()
var lost = false
var current_pipe

func _ready():
	get_node("ScoreLabel").text = "Score: %d" % score
	spawn_pipe()
	current_pipe = pipes[0]

func _process(delta):
	spawn_timer += delta
	if spawn_timer > spawn_interval and not lost:
		spawn_pipe()
		spawn_timer = 0
	
	$QuestionLabel.text = current_pipe.question_text

	# Hapus pipe yang sudah lewat layar kiri
	for pipe in pipes:
		if pipe.position.x < -100:
			pipes.erase(pipe)
			pipe.queue_free()
	
	if current_pipe.position.x <= $Bird.position.x:
		score += 1
		$ScoreLabel.text = "Score: %d" % score
		current_pipe = pipes[1]

func spawn_pipe():
	var q = question_generator.generate_question()
	var pipe = pipe_scene.instantiate()
	pipe.position = Vector2(700, randi_range(200, 280))
	pipe.question_text = q["question"]
	pipe.answer_1_text = q["answer_1"]
	pipe.answer_2_text = q["answer_2"]
	pipe.is_answer_top = q["is_answer_top"]
	pipe.add_to_group("standard_pipes")
	add_child(pipe)
	pipes.append(pipe)

# katanya biar godot banget jangan pake kayak gini, pake signal aja
#func _on_pipe_area_entered(area, pipe):
	## Deteksi jika Bird melewati pipe atau collision
	## Cek jawaban, update skor
	## Asumsi: area/celahan punya nama/cara identifikasi, Anda dapat perluas sinyalnya jika belum ada
	## Tambahkan logika sesuai kebutuhan
	#if area.name == "Bird":
		## Jawaban benar
		#score += 1
		#get_node("ScoreLabel").text = "Score: %d" % score
		## Hapus pipe
		#pipes.erase(pipe)
		#get_node("QuestionLabel").text = pipes[0].question_text
		#pipe.queue_free()
	## Jika butuh penalti atau nyawa, tambahkan di sini


func _on_bird_collide() -> void:
	get_tree().call_group("standard_pipes", "stop")
	lost = true
