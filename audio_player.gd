extends AudioStreamPlayer

const main_menu_music = preload('res://assets/sound/Main menu backsound.mp3')
const normal_stage_music = preload('res://assets/sound/Battle normal stage.mp3')
const boss_stage_music = preload('res://assets/sound/Battle boss stage.mp3')

const click_sfx = preload('res://assets/sound/Button click.mp3')

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func _stop_music():
	stop()

func play_music_main_menu():
	_play_music(main_menu_music)

func play_music_normal():
	_play_music(normal_stage_music)

func play_music_boss():
	_play_music(boss_stage_music)
	
func play_FX(stream: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	fx_player.queue_free()

func play_button_click_FX():
	play_FX(click_sfx)
