extends Resource

class_name QuestionGenerator

func generate_question(always_true_on_top := false, difficulty := "easy"):
	var num1 : int
	var num2 : int
	var operations := []
	
	# Tentukan rentang angka & operasi berdasarkan tingkat kesulitan
	match difficulty:
		"easy":
			num1 = randi_range(1, 20)
			num2 = randi_range(1, 20)
			operations = ["+"]
			
		"medium":
			num1 = randi_range(10, 50)
			num2 = randi_range(10, 50)
			operations = ["+", "-", "x"]
			
		"hard":
			num1 = randi_range(1, 10)
			num2 = randi_range(20, 100)
			operations = ["+", "-", "x", "/"]

		_:
			push_error("Unknown difficulty. Use easy/medium/hard.")
			return
	
	# Pilih operasi acak
	var op = operations[randi() % operations.size()]
	var answer : int
	
	# Hitung jawaban sesuai operasi
	match op:
		"+":
			answer = num1 + num2
		"-":
			answer = num1 - num2
		"x":
			answer = num1 * num2
		"/":
			# Untuk pembagian, pastikan hasil bilangan bulat
			num2 = max(1, randi_range(1, 10)) # hindari pembagian 0
			answer = num1
			num1 = answer * num2 # num1 selalu kelipatan num2
		_:
			answer = 0
	
	# Buat jawaban salah
	var wrong_answer = answer
	while wrong_answer == answer:
		wrong_answer = answer + randi_range(-10, 10)
		if wrong_answer < 0:
			wrong_answer = answer + abs(randi_range(1, 10))
	
	# Randomisasi posisi jawaban
	var is_true_on_top = randf() < 0.5 if not always_true_on_top else true

	# Bentuk teks pertanyaan
	var question_text = "%d %s %d = ?" % [num1, op, num2]

	if is_true_on_top:
		return {
			"question": question_text,
			"answer_1": str(answer),
			"answer_2": str(wrong_answer),
			"is_answer_top": true
		}
	else:
		return {
			"question": question_text,
			"answer_1": str(wrong_answer),
			"answer_2": str(answer),
			"is_answer_top": false
		}
