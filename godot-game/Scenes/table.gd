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
	_update_buttons()

func _move_left():
	all_buttons.append(all_buttons.pop_front()) # Сдвиг влево
	_update_buttons()

func _move_right():
	all_buttons.push_front(all_buttons.pop_back()) # Сдвиг вправо
	_update_buttons()

func _update_buttons():
	for btn in all_buttons:
		btn.visible = false

	for i in range(3):
		var btn = all_buttons[i]
		btn.visible = true
		if btn.get_parent() != buttons_container:
			buttons_container.add_child(btn)
		buttons_container.move_child(btn, i)
