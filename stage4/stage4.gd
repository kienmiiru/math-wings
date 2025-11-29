extends Node

@export var standard_pipe_scene : PackedScene = preload("res://stage3/standard_pipe.tscn")
@export var boss_scene : PackedScene = preload("res://stage4/boss_1.tscn")
@export var question_generator_res : Resource = preload("res://question_generator.gd")

var phase := 0 # 0: pipa, 1: serangan
var pipes = []
var boss = null
var question_data = null
var standard_pipe_to_spawn := 5
var standard_made := 0
var spawn_timer := 0.0
var lost := false
var answer_choices = []
var correct_answer_idx = 0
var lasers = []
var bird = null
var question_generator = QuestionGenerator.new()

func _ready():
	bird = $Bird
	start_pipe_phase()

func start_pipe_phase():
	phase = 0
	question_data = question_generator.generate_question()
	$HUDStage4.update_question(question_data["question"])
	$HUDStage4.show_question()
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

func spawn_standard_pipe():
	var pipe = standard_pipe_scene.instantiate()
	pipe.position = Vector2(700, randi_range(160, 320))
	add_child(pipe)
	pipes.append(pipe)

func start_attack_phase():
	phase = 1
	$HUDStage4.hide_question()
	if boss == null:
		boss = boss_scene.instantiate()
		add_child(boss)
	boss.start_attack()
	prepare_answers_and_lasers()

func prepare_answers_and_lasers():
	# Jawaban: satu benar, dua salah, acak posisi
	var answers = [question_data["answer_1"], question_data["answer_2"], str(randi_range(0, 99))]
	answers.shuffle()
	correct_answer_idx = answers.find(question_data["answer_1"])
	answer_choices.clear()
	lasers.clear()
	var y_positions = [100, 240, 380]
	for i in range(3):
		# Spawn label jawaban
		var label = Label.new()
		label.text = answers[i]
		label.position = Vector2(600, y_positions[i])
		add_child(label)
		answer_choices.append(label)
		# Spawn laser
		var laser_scene = preload("res://stage4/laser.tscn")
		var laser = laser_scene.instantiate()
		laser.position = Vector2(720/2, y_positions[i]-8)
		laser.set_on(false)
		add_child(laser)
		lasers.append(laser)

	# Timer untuk menyalakan laser
	var t = Timer.new()
	t.wait_time = 2.5
	t.one_shot = true
	t.connect("timeout", Callable(self, "activate_lasers"))
	add_child(t)
	t.start()

func activate_lasers():
	# Nyalakan dua laser salah, matikan laser benar
	for i in range(3):
		lasers[i].set_on(i != correct_answer_idx)
	# Timer deteksi bird kena laser
	var t = Timer.new()
	t.wait_time = 1.0
	t.one_shot = true
	t.connect("timeout", Callable(self, "check_bird_laser_collision"))
	add_child(t)
	t.start()

func check_bird_laser_collision():
	for i in range(3):
		if i != correct_answer_idx and lasers[i].is_on:
			var area = lasers[i].get_node("Area2D")
			if area and area.overlaps_body(bird):
				on_bird_hit_laser()
	# Bersihkan jawaban dan laser
	for l in lasers:
		l.queue_free()
	for a in answer_choices:
		a.queue_free()
	# Kembali ke fase pipa jika boss belum kalah
	if boss and boss.hp > 0:
		start_pipe_phase()


func on_bird_hit_laser():
	bird.hp -= bird.max_hp * 0.25
	if bird.hp <= 0:
		lost = true
		# TODO: handle game over

func on_boss_defeated():
	# TODO: handle victory
	pass

func _on_bullet_hit_boss(damage):
	if boss:
		boss.take_damage(damage)
		$HUDStage4.update_score(boss.hp)
		if boss.hp <= 0:
			on_boss_defeated()
