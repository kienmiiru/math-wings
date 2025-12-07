extends Area2D
signal collide

var velocity = Vector2.ZERO
const GRAVITY = 1000.0
const JUMP_FORCE = -350.0

var hp := 1.0 # Representasi 100% HP
var alive := true

func _physics_process(delta):
	velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("flap") and alive:
		velocity.y = JUMP_FORCE
		$AnimatedSprite2D.play('flap')
		

	position.y += velocity.y * delta

func start(pos):
	position = pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_hp_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_hp_display():
	var stage = get_tree().current_scene
	if stage.has_node("HUDStage1"):
		stage.get_node("HUDStage1").update_hp(hp)
	elif stage.has_node("HUDStage2"):
		stage.get_node("HUDStage2").update_hp(hp)
	elif stage.has_node("HUDStage3"):
		stage.get_node("HUDStage3").update_hp(hp)
	elif stage.has_node("HUDStage4"):
		stage.get_node("HUDStage4").update_hp(hp)
	elif stage.has_node("HUDStage5"):
		stage.get_node("HUDStage5").update_hp(hp)

func take_damage(amount: float):
	if !alive:
		return
	hp -= amount
	if hp <= 0.0:
		hp = 0.0
		alive = false
		emit_signal("collide")
		$AnimatedSprite2D.play('die')
	_update_hp_display()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("pipe_collision") && alive && not area.is_hit:
		area.is_hit = true
		take_damage(0.15)
		#for child in area.get_children():
			#if child is CollisionShape2D:
				#child.set_deferred("disabled", true)
	if area.is_in_group("bullet_collision") && alive && not area.is_hit:
		area.is_hit = true
		area.queue_free()
		take_damage(0.10)
	
	if area.is_in_group("laser") && alive:
		take_damage(0.25)
		area.is_hit = true

	if area.is_in_group("missile") && alive:
		take_damage(0.10)
		area.queue_free()
		area.is_hit = true
