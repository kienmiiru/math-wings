extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$Story.hide()
			$SwitchModeButton/NextButton.hide()
			$Endless.show()
			$SwitchModeButton/PrevButton.show()


func _on_prev_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$Story.show()
			$SwitchModeButton/NextButton.show()
			$Endless.hide()
			$SwitchModeButton/PrevButton.hide()

func _on_back_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().change_scene_to_file("res://screens/main_menu.tscn")

func _on_stage_1_button_button_down() -> void:
	get_tree().change_scene_to_file("res://stage1/level_select.tscn")


func _on_stage_2_button_button_down() -> void:
	get_tree().change_scene_to_file("res://stage2/level_select.tscn")


func _on_stage_3_button_button_down() -> void:
	get_tree().change_scene_to_file("res://stage3/level_select.tscn")


func _on_stage_4_button_button_down() -> void:
	get_tree().change_scene_to_file("res://stage4/level_select.tscn")


func _on_stage_5_button_button_down() -> void:
	get_tree().change_scene_to_file("res://stage5/level_select.tscn")
