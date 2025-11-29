extends Node

@export var two_choice_pipe_scene : PackedScene = preload("res://stage1/two_choice_pipe.tscn")
@export var standard_pipe_scene : PackedScene = preload("res://stage3/standard_pipe.tscn")
@export var question_generator_res : Resource = preload("res://question_generator.gd")

var score := 0
var pipes = []
var spawn_timer := 0.0
var lost = false
var phase = 0
var question_data = null
var standard_pipe_to_spawn := 5  # Atur sesuai keinginan
var standard_made := 0
var current_pipe

var question_generator = QuestionGenerator.new()

func _ready():
	spawn_phase()
	$HUDStage3.update_score(score)

func spawn_phase():
	# Tampilkan soal ke pemain
	question_data = question_generator.generate_question()
	$HUDStage3.update_question(question_data["question"])
	$HUDStage3.show_question()
	spawn_timer = 0.0
	phase = 0
	standard_made = 0

func _process(delta):
	if lost:
		return
	spawn_timer += delta

	if phase == 0 and spawn_timer > 2.0:
		# Hide pertanyaan setelah beberapa detik
		$HUDStage3.hide_question()
		phase = 1
		spawn_timer = 0.0
	elif phase == 1:
		# Spawn StandardPipe satu per satu
		if standard_made < standard_pipe_to_spawn and spawn_timer > 1.1:
			spawn_standard_pipe()
			spawn_timer = 0.0
			standard_made += 1
		elif standard_made == standard_pipe_to_spawn and spawn_timer > 1.0:
			phase = 2
			spawn_timer = 0.0
	elif phase == 2:
		spawn_two_choice_pipe()
		phase = 3
	elif phase == 3:
		# Tunggu dua_choice_pipe lewat, deteksi via pipes (bereskan ketika tidak di layar)
		var last_pipe = pipes[-1] if pipes.size() > 0 else null
		if last_pipe and last_pipe.position.x < -100:
			pipes.pop_front()
			spawn_phase()

	if current_pipe and current_pipe.position.x <= $Bird.position.x:
		if not current_pipe.is_hit:
			score += 1
		$HUDStage3.update_score(score)
		if pipes.size() > 1:
			current_pipe = pipes[1]
		else:
			current_pipe = null

	# Clean up pipe yang sudah lewat layar
	for pipe in pipes:
		if pipe.position.x < -100:
			pipes.erase(pipe)
			pipe.queue_free()

func spawn_standard_pipe():
	var pipe = standard_pipe_scene.instantiate()
	pipe.position = Vector2(700, randi_range(160, 320))
	add_child(pipe)
	pipes.append(pipe)
	if current_pipe == null:
		current_pipe = pipe

func spawn_two_choice_pipe():
	var pipe = two_choice_pipe_scene.instantiate()
	pipe.position = Vector2(700, randi_range(200, 280))
	pipe.question_text = question_data["question"]
	pipe.answer_1_text = question_data["answer_1"]
	pipe.answer_2_text = question_data["answer_2"]
	pipe.is_answer_top = question_data["is_answer_top"]
	pipe.add_to_group("pipe_collision")
	add_child(pipe)
	pipes.append(pipe)
	if current_pipe == null:
		current_pipe = pipe

func _on_bird_collide():
	if $Bird.hp <= 0.0:
		get_tree().call_group("pipe_collision", "stop")
		lost = true
