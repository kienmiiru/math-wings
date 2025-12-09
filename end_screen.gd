extends Control

var is_win: bool = false
var coin = 0

func _ready():
	if is_win:
		$Label.text = "Selamat! Kamu Menang!\nKoin Diperoleh: " + str(coin)
		$RestartButton.hide()
	else:
		$Label.text = "Kamu Kalah! Coba Lagi.\nKoin Diperoleh: " + str(coin)
		$NextLevelButton.hide()

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://screens/stage_menu.tscn")

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://screens/main_menu.tscn")


func _on_next_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://screens/stage_menu.tscn")
