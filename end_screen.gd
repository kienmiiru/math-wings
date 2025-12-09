extends Control

var is_win: bool = false
var coin = 0

func _ready():
	AudioPlayer._stop_music()
	if is_win:
		$Label.text = "Selamat! Kamu Menang!\nKoin Diperoleh: " + str(coin)
		$RestartButton.hide()
	else:
		$Label.text = "Kamu Kalah! Coba Lagi.\nKoin Diperoleh: " + str(coin)
		$NextLevelButton.hide()
	
	var current_coin = Saver.get_coin()
	print('Current coin: %d' % current_coin)
	current_coin += coin
	print('Coin now: %d' % current_coin)
	Saver.set_coin(current_coin)

func _on_restart_button_pressed():
	AudioPlayer.play_button_click_FX()
	get_tree().change_scene_to_file("res://screens/stage_menu.tscn")

func _on_menu_button_pressed():
	AudioPlayer.play_button_click_FX()
	get_tree().change_scene_to_file("res://screens/main_menu.tscn")


func _on_next_level_button_pressed() -> void:
	AudioPlayer.play_button_click_FX()
	get_tree().change_scene_to_file("res://screens/stage_menu.tscn")
