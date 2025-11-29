extends Node2D

@export var fire_interval := 2
@export var bullet_scene: PackedScene = preload("res://stage2/turret_bullet.tscn")
var fire_timer := 0.0
@export var shooting_power := 400.0

var target: Node2D = null
var hp := 1.0 # 100% HP
var alive := true

func _ready():
	fire_timer = 0.0
	find_target()
	$CanonHead.play()

func find_target():
	# TODO: For now, assumes Bird is named "Bird" in the root/main scene
	var root = get_tree().current_scene
	if root.has_node("Bird"):
		target = root.get_node("Bird")

func _process(delta):
	if target == null:
		find_target()
		return
	
	if target != null:
		var direction = (target.global_position - $CanonHead.global_position).normalized()
		$CanonHead.rotation = direction.angle()

	fire_timer += delta
	if fire_timer >= fire_interval:
		shoot_at_target()
		fire_timer = 0.0

func shoot_at_target():
	if target == null:
		return
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $CanonHead/MuzzlePoint.global_position
	var direction = (target.global_position - global_position).normalized()
	bullet.rotation = direction.angle()
	if bullet.has_method("set_speed_vector"):
		bullet.set_speed_vector(direction * shooting_power)
	get_tree().current_scene.add_child(bullet)

func take_damage(amount: float):
	if !alive:
		return
	hp -= amount
	if hp <= 0.0:
		hp = 0.0
		alive = false
		queue_free() # Atau efek ledakan
