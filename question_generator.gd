extends Resource

class_name QuestionGenerator

func generate_question():
	# Rentang angka bisa diatur sesuai tingkat kesulitan (untuk Stage 1: sederhana)
	var num1 = randi_range(1, 20)
	var num2 = randi_range(1, 20)
	var answer = num1 + num2
	var wrong_answer = answer
	# Pastikan jawaban salah != benar
	while wrong_answer == answer:
		wrong_answer = answer + randi_range(-10, 10)
		if wrong_answer < 0:
			wrong_answer = answer + abs(randi_range(1, 10))

	# Randomize letak jawaban
	var is_true_on_top = randf() < 0.5
	if is_true_on_top:
		return {
			"question": "%d + %d = ?" % [num1, num2],
			"answer_1": str(answer),
			"answer_2": str(wrong_answer),
			"is_answer_top": true
		}
	else:
		return {
			"question": "%d + %d = ?" % [num1, num2],
			"answer_1": str(wrong_answer),
			"answer_2": str(answer),
			"is_answer_top": false
		}
