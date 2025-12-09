class_name Saver

const COIN_PATH = "user://coin.save"
const POWERUP_PATH = "user://powerup.save"

static func get_coin():
	if FileAccess.file_exists(COIN_PATH):
		var file = FileAccess.open(COIN_PATH, FileAccess.READ)
		var coin = file.get_var()
		file.close()
		return coin
	else:
		return 0

static func set_coin(val):
	var file = FileAccess.open(POWERUP_PATH, FileAccess.WRITE)
	file.store_var(val)
	file.close()

static func get_powerup():
	if FileAccess.file_exists(POWERUP_PATH):
		var file = FileAccess.open(POWERUP_PATH, FileAccess.READ)
		var powerup = file.get_var()
		file.close()
		return powerup
	else:
		return [false, false, false]

static func set_powerup(val):
	var file = FileAccess.open(POWERUP_PATH, FileAccess.WRITE)
	file.store_var(val)
	file.close()
