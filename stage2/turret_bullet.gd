extends Area2D

var speed_vector := Vector2.ZERO
@export var damage := 10

func _ready():
	add_to_group("turret_bullets")

func set_speed_vector(vec: Vector2):
	speed_vector = vec

func _physics_process(delta):
	position += speed_vector * delta

func _on_area_entered(area):
	if area.is_in_group("bird"):
		# area assumed to be Bird or similar, reduce HP
		if area.has_method("take_damage"):
			area.take_damage(damage)
		queue_free()
