extends Node2D 

var accumulated_scroll = 0.0  # Накопленный сдвиг
var scroll_threshold = 300  # Увеличиваем расстояние, которое нужно пройти мыши для смены кнопок
var max_scroll_speed = 50 

var buttons = []
var positions = []
var target_positions = []
var dragging = false
var dragging_button = null
var original_position = Vector2()
var last_mouse_x = 0
var scroll_area = Rect2()
@onready var audio_player = $AudioStreamPlayer
var button_sounds = {}
@onready var panel2 = $Panel2

var center_area = Rect2()
var returning_buttons = {}  # Отслеживание кнопок, которые возвращаются
var offset = Vector2.ZERO
var is_music_playing = false  # Флаг для отслеживания состояния музыки

func _ready():
	buttons = [
		$Button6, $Button2, $Button4, $Button5, $Button, $Button7, $Button8, $Button9, $Button10, $Button11
	]

	button_sounds = {
		$Button6: preload("res://Rock.mp3"),
		$Button2: preload("res://Latin.mp3"),
		$Button4: preload("res://Kpop.mp3"),
		$Button5: preload("res://House.mp3"),
		$Button: preload("res://Hiphop.mp3"),
		$Button7: preload("res://Pop.mp3"),
		$Button8: preload("res://Metal.mp3"),
		$Button9: preload("res://Classical.mp3"),
		$Button10: preload("res://Country.mp3"),
		$Button11: preload("res://Jazz.mp3")
	}

	# Музыка не играет при загрузке сцены
	audio_player.stop()

	# Запоминаем исходные позиции кнопок
	for btn in buttons:
		positions.append(btn.global_position)

	update_buttons()
	calculate_scroll_area()

func _process(delta):
	center_area.position = panel2.global_position - center_area.size / 2
	center_area.size = panel2.size

func update_buttons(animated = true):
	var center_index = 2  # Третья кнопка центральная
	
	for i in range(buttons.size()):
		var target_pos = positions[i]
		var scale_factor = 0.8 
		
		if i == center_index:
			scale_factor = 1.2  
		elif i == center_index - 1 or i == center_index + 1:
			scale_factor = 1.0  

		if animated:
			var tween = get_tree().create_tween()
			tween.tween_property(buttons[i], "global_position", target_pos, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.tween_property(buttons[i], "scale", Vector2(scale_factor, scale_factor), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		else:
			buttons[i].global_position = target_pos
			buttons[i].scale = Vector2(scale_factor, scale_factor)

		buttons[i].visible = i >= center_index - 2 and i <= center_index + 2
		buttons[i].mouse_filter = Control.MOUSE_FILTER_IGNORE if i != center_index else Control.MOUSE_FILTER_STOP

	calculate_scroll_area()

func play_music_for_button(button):
	if button in button_sounds:
		audio_player.stream = button_sounds[button]
		audio_player.play()

func calculate_scroll_area():
	var left_limit = positions[0].x - 400
	var right_limit = positions[-1].x + 400
	var top_limit = positions[0].y - 400 
	var bottom_limit = positions[0].y + 400

	scroll_area = Rect2(Vector2(left_limit, top_limit), Vector2(right_limit - left_limit, bottom_limit - top_limit))

func _move_right():
	buttons.push_front(buttons.pop_back())
	update_buttons(true)

func _move_left():
	buttons.push_back(buttons.pop_front())
	update_buttons(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				# Если музыка уже играет, остановим её
				if is_music_playing:
					audio_player.stop()
					is_music_playing = false
				# Иначе воспроизводим музыку
				else:
					play_music_for_button(buttons[2])
					is_music_playing = true
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				audio_player.stop()  # Музыка отключается при нажатии ЛКМ
				if buttons[2].get_rect().has_point(event.position) and buttons[2] not in returning_buttons:
					dragging = true
					dragging_button = buttons[2]
					original_position = dragging_button.global_position
					offset = dragging_button.global_position - event.position
				elif scroll_area.has_point(event.position):
					dragging = true
					last_mouse_x = event.position.x
			else:
				if dragging_button:
					if center_area.has_point(dragging_button.global_position):
						dragging_button.global_position = original_position
						process_button_action(dragging_button)
					else:
						returning_buttons[dragging_button] = true
						var return_tween = get_tree().create_tween()
						return_tween.tween_property(dragging_button, "global_position", original_position, 2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
						await return_tween.finished
						returning_buttons.erase(dragging_button)
					dragging_button = null
				dragging = false

	if event is InputEventMouseMotion:
		if dragging:
			if dragging_button and dragging_button not in returning_buttons:
				dragging_button.global_position = event.position + offset
			elif not dragging_button:
				var delta_x = event.position.x - last_mouse_x
				delta_x = clamp(delta_x, -max_scroll_speed, max_scroll_speed)
				
				accumulated_scroll += delta_x

				if accumulated_scroll <= -scroll_threshold:
					_move_left()
					accumulated_scroll = 0
				elif accumulated_scroll >= scroll_threshold:
					_move_right()
					accumulated_scroll = 0

				last_mouse_x = event.position.x

func process_button_action(button):
	audio_player.stop()
	if button == $Button6:
		button6()
	elif button == $Button2:
		button2()
	elif button == $Button4:
		button4()
	elif button == $Button5:
		button5()
	elif button == $Button:
		button()
	elif button == $Button7:
		button7()
	elif button == $Button8:
		button8()
	elif button == $Button9:
		button9()
	elif button == $Button10:
		button10()
	elif button == $Button11:
		button11()

func check_lives():
	if Main.lives <= 0:
		get_tree().change_scene_to_file("res://Scenes/losescene.tscn")

func check_two_times():
	if Main.two_times == 0:
		Main.lives -= 1
		check_lives()
		Main.two_times = 2		
		Main.characters += 1

func button():
	Main.two_times -= 1
	check_two_times()

func button2():
	Main.two_times -= 1
	check_two_times()

func button4():
	Main.two_times -= 1
	check_two_times()

func button5():
	Main.two_times -= 1
	check_two_times()

func button6():
	Main.two_times -= 1
	check_two_times()

func button7():
	Main.two_times -= 1
	check_two_times()

func button8():
	Main.two_times -= 1
	check_two_times()

func button9():
	Main.two_times -= 1
	check_two_times()

func button10():
	Main.two_times -= 1
	check_two_times()

func button11():
	if Main.characters == 10:	
		Main.points += 1
		get_tree().change_scene_to_file("res://Scenes/winscene.tscn")
	else:
		Main.two_times -= 1
		check_two_times()

func close_game():
	get_tree().quit()

func restart_game():
	audio_player.stop()
	get_tree().reload_current_scene()




















































func music():
	$AudioStreamPlayer.play()
func music1():
	$AudioStreamPlayer1.play()
func music2():
	$AudioStreamPlayer2.play()
func music3():
	$AudioStreamPlayer3.play()
func music4():
	$AudioStreamPlayer4.play()
	
	
	
