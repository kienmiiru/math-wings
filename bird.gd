extends Area2D
signal collide

var velocity = Vector2.ZERO
const GRAVITY = 1000.0
const JUMP_FORCE = -350.0

func _physics_process(delta):
	velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("flap"):
		velocity.y = JUMP_FORCE

	position.y += velocity.y * delta

func start(pos):
	position = pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	print(area, area.get_groups())
	collide.emit()
	$CollisionShape2D.set_deferred("disabled", true)
