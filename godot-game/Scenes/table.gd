extends Node2D

var buttons = []
var positions = []
var dragging = false
var dragging_button = null
var original_position = Vector2()
var last_mouse_x = 0
var scroll_area = Rect2()
@onready var audio_player = $AudioStreamPlayer
var button_sounds = {}
@onready var panel2 = $Panel2

var center_area = Rect2()
var returning_buttons = {}  # Словарь для отслеживания кнопок, которые возвращаются

func _ready():
	buttons = [
		$Button6, $Button2, $Button4, $Button5, $Button
	]
	button_sounds = {
		$Button6: preload("res://sound1.mp3"),
		$Button2: preload("res://sound2.mp3"),
		$Button4: preload("res://sound3.mp3"),
		$Button5: preload("res://sound4.mp3"),
		$Button: preload("res://sound5.mp3")
	}
	for btn in buttons:
		positions.append(btn.global_position)

	update_buttons()
	calculate_scroll_area()

func _process(delta):
	# Центрируем область по Panel2
	center_area.position = panel2.global_position - center_area.size / 2
	center_area.size = panel2.size

func update_buttons():
	for i in range(buttons.size()):
		buttons[i].global_position = positions[i]
		buttons[i].visible = i < 3  
		buttons[i].mouse_filter = Control.MOUSE_FILTER_IGNORE  

		# Изменение размера кнопок
		if i == 1:
			buttons[i].scale = Vector2(1.2, 1.2)  # Центральная кнопка большая
			buttons[i].mouse_filter = Control.MOUSE_FILTER_STOP  
		else:
			buttons[i].scale = Vector2(0.8, 0.8)  # Остальные кнопки маленькие

	play_music_for_button(buttons[1])
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
	update_buttons()

func _move_left():
	buttons.push_back(buttons.pop_front())
	update_buttons()
var offset = Vector2.ZERO  # Объявляем переменную offset

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Разрешаем перетаскивать только центральную кнопку, если она не возвращается
				if buttons[1].get_rect().has_point(event.position) and buttons[1] not in returning_buttons:
					dragging = true
					dragging_button = buttons[1]
					original_position = dragging_button.global_position
					offset = dragging_button.global_position - event.position  # Запоминаем смещение между курсором и кнопкой
				# Если кликнули в область скролла (но не по центральной кнопке), включаем горизонтальный скроллинг
				elif scroll_area.has_point(event.position):
					dragging = true
					last_mouse_x = event.position.x

			else:
				if dragging_button:
					if center_area.has_point(dragging_button.global_position):
						# Кнопка мгновенно возвращается и срабатывает функция
						dragging_button.global_position = original_position
						process_button_action(dragging_button)
					else:
						# Кнопка плавно возвращается за 2 секунды
						returning_buttons[dragging_button] = true
						var tween = get_tree().create_tween()
						tween.tween_property(dragging_button, "global_position", original_position, 1)
						await tween.finished
						returning_buttons.erase(dragging_button)  # После возврата кнопка снова кликабельна
					dragging_button = null
				dragging = false

	if event is InputEventMouseMotion:
		if dragging:
			if dragging_button and dragging_button not in returning_buttons:
				# Центральная кнопка теперь следует за курсором по X и Y с учетом смещения
				dragging_button.global_position = event.position + offset
			elif not dragging_button:
				# Горизонтальный скроллинг при движении мыши (если нет активного перетаскивания кнопки)
				var delta_x = event.position.x - last_mouse_x
				if delta_x < -20: 
					_move_left()
					last_mouse_x = event.position.x
				elif delta_x > 20:  
					_move_right()
					last_mouse_x = event.position.x



func process_button_action(button):
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

func check_lives():
	if Main.lives <= 0:
		get_tree().quit()

func check_two_times():
	if Main.two_times == 0:
		Main.lives -= 1
		check_lives()
		Main.two_times = 2		
		Main.characters += 1

func button():
	if Main.characters == 1:
		Main.points += 1
		Main.characters += 1
		Main.two_times = 2
	else:
		Main.two_times -= 1
		check_two_times()

func button2():
	if Main.characters == 2:	
		Main.points += 1
		Main.characters += 1
		Main.two_times = 2
	else:
		Main.two_times -= 1
		check_two_times()

func button4():
	if Main.characters == 3:	
		Main.points += 1
		Main.characters += 1
		Main.two_times = 2
	else:
		Main.two_times -= 1
		check_two_times()

func button5():
	if Main.characters == 4:	
		Main.points += 1
		Main.characters += 1
		Main.two_times = 2
	else:
		Main.two_times -= 1
		check_two_times()

func button6():
	if Main.characters == 5:	
		Main.points += 1
		get_tree().quit()
	else:
		Main.two_times -= 1
		check_two_times()

func close_game():
	get_tree().quit()

func restart_game():
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
	
	
	
