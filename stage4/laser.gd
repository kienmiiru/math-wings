extends Node2D

@export var is_on: bool = false
@export var laser_length: float = 800.0
@export var color_on: Color = Color(1,0,0,0.7)
@export var color_off: Color = Color(1,0,0,0.2)

func _draw():
	if is_on:
		$Area2D/ColorRect.color = color_on
	else:
		$Area2D/ColorRect.color = color_off

func set_on(on: bool):
	is_on = on
	queue_redraw()

func _ready():
	$Area2D/ColorRect.color = color_off
	queue_redraw()
