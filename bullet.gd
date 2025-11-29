extends Area2D
@export var speed := 600.0  # pixels/sec
@export var damage := 1 # 50% default

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("bird_bullets")


func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_area_entered(area):
	if area.has_method("take_damage") and area.is_in_group("turret"):
		area.take_damage(damage)
		queue_free()
