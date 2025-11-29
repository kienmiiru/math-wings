extends Area2D
var is_broken = false
var is_hit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if not is_broken and area.is_in_group("bird_bullets"):
		is_broken = true
		$CollisionShape2D.set_deferred("disabled", true)
		$ColorRect.color = "#ffffff00"
		area.queue_free()
