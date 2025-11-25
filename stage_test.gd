extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bird.position = $StartPosition.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bird_collide() -> void:
	get_tree().call_group("standard_pipes", "stop")
