extends Area2D
signal collide

var velocity = Vector2.ZERO
const GRAVITY = 1000.0
const JUMP_FORCE = -350.0

var hp := 1.0 # Representasi 100% HP
var alive := true
var immune = false
var double_coin = false

var powerup_1_available = true
var powerup_2_available = true
var powerup_3_available = true

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
	if Input.is_action_just_pressed("power_up_1") and powerup_1_available:
		powerup_1_available = false
		activate_slowdown()
	
	if Input.is_action_just_pressed("power_up_2") and powerup_2_available:
		powerup_2_available = false
		activate_shield()
	
	if Input.is_action_just_pressed("power_up_3") and powerup_3_available:
		powerup_3_available = false
		activate_double_coin()

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
	if immune and amount != 1.0:
		return
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
	
	if area.is_in_group("floor") && alive:
		take_damage(1)
		area.queue_free()

signal powerup_1_activated
signal powerup_2_activated
signal powerup_3_activated

func activate_slowdown():
	Engine.time_scale = 0.75
	Engine.physics_ticks_per_second = 90
	$Slowdown.show()
	$Slowdown.play()
	powerup_1_activated.emit()
	await get_tree().create_timer(3).timeout
	deactivate_slowdown()

func deactivate_slowdown():
	Engine.time_scale = 1
	Engine.physics_ticks_per_second = 60
	$Slowdown.stop()
	$Slowdown.hide()

func activate_shield():
	immune = true
	$Shield.show()
	$Shield.play()
	powerup_2_activated.emit()
	await get_tree().create_timer(5).timeout
	deactivate_shield()

func deactivate_shield():
	immune = false
	$Shield.stop()
	$Shield.hide()

func activate_double_coin():
	double_coin = true
	$Coin.show()
	$Coin.play()
	powerup_3_activated.emit()
	await get_tree().create_timer(10).timeout
	deactivate_double_coin()

func deactivate_double_coin():
	double_coin = false
	$Coin.stop()
	$Coin.hide()
