extends Node

@export var standard_pipe_scene : PackedScene = preload("res://stage3/standard_pipe.tscn")
@export var question_generator_res : Resource = preload("res://question_generator.gd")

var phase := 0 # 0: pipa, 1: serangan
var pipes = []
@onready var boss = $Boss1
var question_data = null
var standard_pipe_to_spawn := 5
var standard_made := 0
var spawn_timer := 0.0
var lost := false
var correct_answer_idx = 0
var bird = null
var question_generator = QuestionGenerator.new()

func _ready():
	bird = $Bird
	start_pipe_phase()

func start_pipe_phase():
	phase = 0
	question_data = question_generator.generate_question(true, 'hard')
	$HUDStage4.update_question(question_data["question"])
	$HUDStage4.show_question()
	$HUDStage4.hide_answers()
	spawn_timer = 0.0
	standard_made = 0
	pipes.clear()

func _process(delta):
	if lost:
		return
	spawn_timer += delta
	if phase == 0:
		if standard_made < standard_pipe_to_spawn and spawn_timer > 1.1:
			spawn_standard_pipe()
			spawn_timer = 0.0
			standard_made += 1
		elif standard_made == standard_pipe_to_spawn and spawn_timer > 1.0:
			start_attack_phase()
	elif phase == 1:
		# Attack phase handled by boss and laser logic
		pass
	elif phase == 2:
		print('win')

func spawn_standard_pipe():
	var pipe = standard_pipe_scene.instantiate()
	pipe.position = Vector2(700, randi_range(160, 320))
	add_child(pipe)
	pipes.append(pipe)

func start_attack_phase():
	phase = 1
	$HUDStage4.hide_question()
	var answers = [question_data["answer_1"], question_data["answer_2"], str(randi_range(0, 99))]
	answers.shuffle()
	correct_answer_idx = answers.find(question_data["answer_1"])
	$HUDStage4.set_answers(answers[0], answers[1], answers[2])
	$HUDStage4.show_answers()
	boss.start_attack(correct_answer_idx)

func activate_lasers():
	var t = Timer.new()
	t.wait_time = 1.0
	t.one_shot = true
	t.connect("timeout", Callable(self, "start_pipe_phase"))
	add_child(t)
	t.start()

func _on_boss_1_attack_complete() -> void:
	start_pipe_phase()


func _on_bird_collide() -> void:
	get_tree().call_group("pipe_collision", "stop")
	lost = true

func _on_boss_1_died() -> void:
	get_tree().call_group("pipe_collision", "stop")
	phase = 2
