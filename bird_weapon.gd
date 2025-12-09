extends Node2D

@export var bullet_scene: PackedScene = preload("res://bullet.tscn")
@export var shoot_cooldown := 1
var cooldown_timer := 0.0

@onready var shoot_sfx = preload("res://assets/sound/Char Gun (mp3cut.net).mp3")

func _ready():
	cooldown_timer = 0.0

func _process(delta):
	if cooldown_timer > 0:
		cooldown_timer -= delta
	if Input.is_action_just_pressed("shoot") and cooldown_timer <= 0:
		shoot()
		cooldown_timer = shoot_cooldown

func shoot():
	AudioPlayer.play_FX(shoot_sfx)
	var bullet = bullet_scene.instantiate()
	var direction = (get_global_mouse_position() - global_position).normalized()
	bullet.global_position = global_position
	bullet.rotation = direction.angle()
	get_tree().current_scene.add_child(bullet)
