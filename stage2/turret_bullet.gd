extends Area2D

var speed_vector := Vector2.ZERO
@export var damage := 10
var is_hit = false

func _ready():
	add_to_group("turret_bullets")

func set_speed_vector(vec: Vector2):
	speed_vector = vec

func _physics_process(delta):
	position += speed_vector * delta
