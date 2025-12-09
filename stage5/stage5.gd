extends Node

@export var pipe_scene : PackedScene = preload("res://stage1/two_choice_pipe.tscn")
@export var question_generator_res : Resource = preload("res://question_generator.gd")

var score := 0
var coin = 0
var spawn_timer := 0.0
var spawn_interval := 3 # detik
var pipes = []
var question_generator = QuestionGenerator.new()
var lost = false
var current_pipe

func _ready():
	$HUDStage5.update_score(score)
	spawn_pipe()
	current_pipe = pipes[0]
	
	if $Bird.powerup_1_available:
		$PowerUpHud.show_powerup_1()
	if $Bird.powerup_2_available:
		$PowerUpHud.show_powerup_2()
	if $Bird.powerup_3_available:
		$PowerUpHud.show_powerup_3()

func isWin():
	return $Boss2.hp <= 0

func isLose():
	return lost

func _process(delta):
	if isWin():
		var end_screen_scene = load("res://end_screen.tscn").instantiate()
		end_screen_scene.is_win = true
		get_tree().get_root().add_child(end_screen_scene)
		queue_free()
		get_tree().current_scene = end_screen_scene

	if isLose():
		var end_screen_scene = load("res://end_screen.tscn").instantiate()
		end_screen_scene.is_win = false
		get_tree().get_root().add_child(end_screen_scene)
		queue_free()
		get_tree().current_scene = end_screen_scene

	spawn_timer += delta
	if spawn_timer > spawn_interval and not lost:
		spawn_pipe()
		spawn_timer = 0

	if current_pipe:
		$HUDStage5.update_question(current_pipe.question_text)

		# Hapus pipe yang sudah lewat layar kiri
		for pipe in pipes:
			if pipe.position.x < -100:
				pipes.erase(pipe)
				pipe.queue_free()
	
		if current_pipe.position.x <= $Bird.position.x:
			if not current_pipe.is_hit:
				score += 1
				if score % 3 == 0:
					$Boss2.start_attack()
				$HUDStage5.update_score(score)
				coin += 1
				if $Bird.double_coin:
					coin += 1
				$HUDStage5.update_coin(coin)
			current_pipe = pipes[1] if pipes.size() > 1 else null
	elif pipes.size() > 1:
		current_pipe = pipes[1]

func spawn_pipe():
	var q = question_generator.generate_question(false, 'hard')
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


func _on_bird_powerup_1_activated() -> void:
	$PowerUpHud.animate_powerup_1()


func _on_bird_powerup_2_activated() -> void:
	$PowerUpHud.animate_powerup_2()


func _on_bird_powerup_3_activated() -> void:
	$PowerUpHud.animate_powerup_3()
