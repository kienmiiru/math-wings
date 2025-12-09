extends Node2D

var coin = 0
var powerup = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin = Saver.get_coin()
	powerup = Saver.get_powerup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
