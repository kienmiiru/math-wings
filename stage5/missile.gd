extends Area2D

# Missile movement parameters
var homing_duration := 1.5 # seconds to home in on Bird
var homing_speed := 220.0
var straight_speed := 300.0
var _homing_time := 0.0
var _homing := true
var _direction := Vector2.RIGHT
var _bird
var is_hit = false

func _ready() -> void:
	# Find the Bird node in the scene tree
	_bird = get_tree().get_root().find_child("Bird", true, false)
	_homing_time = 0.0
	_homing = true
	if _bird:
		look_at(_bird.global_position)
		_direction = ( _bird.global_position - global_position ).normalized()
	else:
		_direction = Vector2.RIGHT

func _process(delta: float) -> void:
	if _homing:
		_homing_time += delta
		if _bird:
			var to_bird = (_bird.global_position - global_position).normalized()
			_direction = to_bird
			look_at(_bird.global_position)
		position += _direction * homing_speed * delta
		if _homing_time >= homing_duration:
			_homing = false
	else:
		position += _direction * straight_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
