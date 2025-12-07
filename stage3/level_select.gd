extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().change_scene_to_file("res://screens/stage_menu.tscn")


func _on_stage_1_button_button_down() -> void:
	var level_scene = load('res://stage3/stage3.tscn').instantiate()
	level_scene.difficulty = 0
	get_tree().get_root().add_child(level_scene)
	queue_free()
	get_tree().current_scene = level_scene


func _on_stage_2_button_button_down() -> void:
	var level_scene = load('res://stage3/stage3.tscn').instantiate()
	level_scene.difficulty = 1
	get_tree().get_root().add_child(level_scene)
	queue_free()
	get_tree().current_scene = level_scene


func _on_stage_3_button_button_down() -> void:
	var level_scene = load('res://stage3/stage3.tscn').instantiate()
	level_scene.difficulty = 2
	get_tree().get_root().add_child(level_scene)
	queue_free()
	get_tree().current_scene = level_scene
