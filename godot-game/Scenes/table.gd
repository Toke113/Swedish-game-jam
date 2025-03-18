extends Node2D

var buttons = []
var positions = []
var dragging = false
var last_mouse_x = 0
var scroll_area = Rect2()  

func _ready():
	buttons = [
		$Button6, $Button2, $Button4, $Button5, $Button
	]

	for btn in buttons:
		positions.append(btn.global_position)
	
	update_buttons()
	calculate_scroll_area() 

func update_buttons():
	for i in range(buttons.size()):
		buttons[i].global_position = positions[i]
		buttons[i].visible = i < 3  

	calculate_scroll_area()  

func calculate_scroll_area():
	
	var left_limit = positions[0].x - 200
	var right_limit = positions[-1].x + 200
	var top_limit = positions[0].y - 200 
	var bottom_limit = positions[0].y + 200

	scroll_area = Rect2(Vector2(left_limit, top_limit), Vector2(right_limit - left_limit, bottom_limit - top_limit))

func _move_right():
	buttons.push_front(buttons.pop_back())
	update_buttons()

func _move_left():
	buttons.push_back(buttons.pop_front())
	update_buttons()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and scroll_area.has_point(event.position):
				dragging = true
				last_mouse_x = event.position.x
			else:
				dragging = false

	if event is InputEventMouseMotion and dragging:
		var delta_x = event.position.x - last_mouse_x
		if abs(delta_x) > 20: 
			if delta_x > 0:
				_move_left()
			else:
				_move_right()
			last_mouse_x = event.position.x  
			
			
func button():
	if Main.characters==1:
		Main.points+=1
		Main.characters+=1
func button2():
	if Main.characters==2:	
		Main.points+=1
		Main.characters+=1
func button4():
	if Main.characters==3:	
		Main.points+=1
		Main.characters+=1
func button5():
	if Main.characters==4:	
		Main.points+=1
		Main.characters+=1
func button6():
	if Main.characters==5:	
		Main.points+=1
		get_tree().quit()









































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
