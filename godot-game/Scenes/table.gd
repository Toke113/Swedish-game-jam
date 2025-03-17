extends Node2D
@onready var buttons_container = $HBoxContainer 
@onready var all_buttons = [
	$HBoxContainer/Button,
	$HBoxContainer/Button2,
	$HBoxContainer/Button4,
	$Control/Button5,
	$Control/Button6
]

func _ready():
	$ButtonLeft.pressed.connect(_move_left)
	$ButtonRight.pressed.connect(_move_right)


func _move_left():
	var last_button = all_buttons.pop_back() 
	all_buttons.push_front(last_button) 

	_update_buttons()


func _move_right():
	var first_button = all_buttons.pop_front() 
	all_buttons.push_back(first_button)  

	_update_buttons()


func _update_buttons():
	var last_button = all_buttons.pop_back()
	all_buttons.push_front(last_button)
	
	for child in buttons_container.get_children():
		buttons_container.remove_child(child)
	
	for i in range(3):
		var btn = all_buttons[i]
		if btn and is_instance_valid(btn):
			if btn.get_parent():
				btn.get_parent().remove_child(btn)
			buttons_container.add_child(btn)
			buttons_container.move_child(btn, i)
