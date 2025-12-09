extends Node2D

var missile_scene = preload("res://stage5/missile.tscn")
var hp: float
var initial_position = Vector2(600, 241)
var positions := [Vector2(600, 100), Vector2(600, 240), Vector2(600, 380)] # Atas, tengah, bawah
var current_pos_idx := 1
var is_attacking := false
var pos_idx = -1
signal attack_complete
signal died

func _ready():
	hp = 1.0
	position = initial_position
	$AnimatedSprite2D.play('idle')
	start_attack()

func start_attack():
	is_attacking = true
	$AnimatedSprite2D.animation = 'attack'
	$AnimatedSprite2D.play()

func fire_missile():
	var missile = missile_scene.instantiate()
	# Tembakkan missile dari depan boss
	missile.global_position = global_position + Vector2(-40, 0)
	get_parent().add_child(missile)

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
		fire_missile()
	elif pos_idx == 0:
		pos_idx = 1
		fire_missile()
	elif pos_idx == 1:
		pos_idx = 2
		fire_missile()
	elif pos_idx == 2:
		pos_idx = -1
		is_attacking = false
		$MoverTimer.stop()
		$AnimatedSprite2D.play("idle")
		await get_tree().create_timer(1).timeout
		attack_complete.emit()
	$MoverTimer.stop()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('bird_bullets'):
		take_damage(0.05)
		area.queue_free()
