extends Node2D

@export var is_on: bool = false
@export var laser_length: float = 800.0
@export var color_on: Color = Color(1,0,0,0.7)
@export var color_off: Color = Color(1,0,0,0.2)
var is_hit = false

func _draw():
	if is_on:
		$AnimatedSprite2D.show()
		$AnimatedSprite2D.play()
		#$ColorRect.color = color_on
	else:
		$AnimatedSprite2D.hide()
		#$ColorRect.color = color_off

func activate():
	is_on = true
	$CollisionShape2D.disabled = false
	queue_redraw()

func _ready():
	$ColorRect.color = color_off
	queue_redraw()
