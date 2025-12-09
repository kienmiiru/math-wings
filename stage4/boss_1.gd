extends Node2D

var laser_scene = preload("res://stage4/laser.tscn")
var hp: float
var initial_position = Vector2(600, 241)
var positions := [Vector2(600, 100), Vector2(600, 240), Vector2(600, 380)] # Atas, tengah, bawah
var current_pos_idx := 1
var lasers = []
var disabled_laser_idx = 0
var is_attacking := false
var pos_idx = -1
signal attack_complete
signal died

@onready var laser_sfx = preload("res://assets/sound/Boss Laser (mp3cut.net).mp3")

func _ready():
	hp = 1.0
	position = initial_position
	$AnimatedSprite2D.play('idle')

func start_attack(answer_idx):
	disabled_laser_idx = answer_idx
	is_attacking = true
	$AnimatedSprite2D.animation = 'attack'
	$AnimatedSprite2D.play()

func place_laser():
	var laser = laser_scene.instantiate()
	laser.position = Vector2(720/2, position.y)
	lasers.append(laser)
	get_parent().add_child(laser)

func activate_lasers():
	AudioPlayer.play_FX(laser_sfx)
	for idx in range(lasers.size()):
		if idx != disabled_laser_idx:
			lasers[idx].activate()

func _process(delta):
	if is_attacking:
		if pos_idx == -1:
			position = position.move_toward(positions[0], 500 * delta)
			if position == positions[0]:
				if $MoverTimer.is_stopped():
					$MoverTimer.start()
		elif pos_idx == 0:
			position = position.move_toward(positions[1], 500 * delta)
			if position == positions[1]:
				if $MoverTimer.is_stopped():
					$MoverTimer.start()
		elif pos_idx == 1:
			position = position.move_toward(positions[2], 500 * delta)
			if position == positions[2]:  
				if $MoverTimer.is_stopped():
					$MoverTimer.start()
		elif pos_idx == 2:
			position = position.move_toward(initial_position, 500 * delta)
			if position == initial_position:
				if $MoverTimer.is_stopped():
					$MoverTimer.start()

func take_damage(amount: float):
	hp -= amount
	$HPBar.value = hp*100
	if hp <= 0:
		#queue_free()
		died.emit()

func _on_mover_timer_timeout() -> void:
	if pos_idx == -1:
		pos_idx = 0
		place_laser()
	elif pos_idx == 0:
		pos_idx = 1
		place_laser()
	elif pos_idx == 1:
		pos_idx = 2
		place_laser()
	elif pos_idx == 2:
		pos_idx = -1
		activate_lasers()
		is_attacking = false
		$MoverTimer.stop()
		$AnimatedSprite2D.play("idle")
		await get_tree().create_timer(1).timeout
		for laser in lasers:
			laser.queue_free()
		lasers.clear()
		attack_complete.emit()
	$MoverTimer.stop()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('bird_bullets'):
		take_damage(0.05)
		area.queue_free()
