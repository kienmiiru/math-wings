extends Node2D

@export var max_hp: int = 20
var hp: int
var positions := [Vector2(600, 100), Vector2(600, 240), Vector2(600, 380)] # Atas, tengah, bawah
var current_pos_idx := 1
var move_timer := 0.0
var move_interval := 1.2
var lasers = []
var is_attacking := false

func _ready():
	hp = max_hp
	position = positions[current_pos_idx]

func start_attack():
	is_attacking = true
	move_timer = 0.0
	$AnimatedSprite2D.animation = 'attack'
	$AnimatedSprite2D.play()
	move_to_next_position()

func move_to_next_position():
	current_pos_idx = (current_pos_idx + 1) % positions.size()
	position = positions[current_pos_idx]
	# TODO: spawn/move lasers to positions

func _process(delta):
	if is_attacking:
		move_timer += delta
		if move_timer > move_interval:
			move_to_next_position()
			move_timer = 0.0

func take_damage(amount: int):
	hp -= amount
	if hp <= 0:
		queue_free()
		# TODO: signal boss defeated
