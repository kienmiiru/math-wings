extends Node2D

@export var bullet_scene: PackedScene = preload("res://bullet.tscn")
@export var shoot_cooldown := 0.3
var cooldown_timer := 0.0

func _ready():
	cooldown_timer = 0.0

func _process(delta):
	if cooldown_timer > 0:
		cooldown_timer -= delta
	if Input.is_action_just_pressed("shoot") and cooldown_timer <= 0:
		shoot()
		cooldown_timer = shoot_cooldown

func shoot():
	var bullet = bullet_scene.instantiate()
	var direction = (get_global_mouse_position() - global_position).normalized()
	bullet.global_position = global_position
	bullet.rotation = direction.angle()
	get_tree().current_scene.add_child(bullet)
	get_parent().get_node('PlayerIdle').hide()
	get_parent().get_node('PlayerFlap').hide()
	get_parent().get_node('PlayerShoot').show()
	get_parent().get_node('PlayerShoot').play()
