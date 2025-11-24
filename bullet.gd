extends Area2D
@export var speed := 300.0  # pixels/sec

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
