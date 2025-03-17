extends Node2D

var buttons = []  
var positions = []  

func _ready():
	
	buttons = [
		$Button6, $Button2, $Button4, $Button5, $Button
	]
	

	for btn in buttons:
		positions.append(btn.global_position)
	
	update_buttons()

func update_buttons():
	
	for i in range(buttons.size()):
		buttons[i].global_position = positions[i]
		buttons[i].visible = i < 3  

func _move_right():
	
	buttons.push_front(buttons.pop_back())
	update_buttons()

func _move_left():
	
	buttons.push_back(buttons.pop_front())
	update_buttons()


func _on_left_button_pressed():
	_move_left()

func _on_right_button_pressed():
	_move_right()
