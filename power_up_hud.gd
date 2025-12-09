extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Slowdown.visible or $Shield.visible or $DoubleCoin.visible:
		$Node.show()
	else:
		$Node.hide()

func show_powerup_1():
	$Slowdown.show()

func hide_powerup_1():
	$Slowdown.hide()

func animate_powerup_1():
	$Slowdown.play()

func show_powerup_2():
	$Shield.show()

func hide_powerup_2():
	$Shield.hide()

func animate_powerup_2():
	$Shield.play()

func show_powerup_3():
	$DoubleCoin.show()

func hide_powerup_3():
	$DoubleCoin.hide()

func animate_powerup_3():
	$DoubleCoin.play()


func _on_double_coin_animation_finished() -> void:
	hide_powerup_3()


func _on_shield_animation_finished() -> void:
	hide_powerup_2()


func _on_slowdown_animation_finished() -> void:
	hide_powerup_1()
