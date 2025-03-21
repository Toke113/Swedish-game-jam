extends Node2D

var desired_music
var time

var hint
var points_on_change

var current_customer:bool = false
var timer_started:bool = false
var moving:bool = false
var enter_store:bool = false
var exit_store:bool = false
var hint_played:bool = false
var two_times_changed:bool = false
var first_hint_active:bool = false
var second_hint_active:bool = false
var points_changed:bool = false

signal change_customer
signal lost_customer
signal active_customer

#TODO Function that sets the value of the customer

func _ready() -> void:
	desired_music = 6
	time = 2
	hint = "I love the number 5"
	Main.characters = desired_music
	
	$Timer/time_left.wait_time = time
	if current_customer:
		$Timer/time_left.start()
	$Timer.max_value = time
	$Timer.value = $Timer/time_left.time_left
	
func _process(delta: float) -> void:
	if enter_store:
		
		var target_position = Vector2(1725,450)
		var speed = 400

		var direction = (target_position-position).normalized()
			
		position += direction * speed * delta
		
		if position.distance_to(target_position) < Main.threshold:
			enter_store = false
	elif moving:
		Main.two_times = 2
		points_on_change = Main.points
		var target_position = Vector2(850,400)
		var speed = 400

		var direction = (target_position-position).normalized()
			
		position += direction * speed * delta
		
		if position.distance_to(target_position) < Main.threshold:
			moving = false
			current_customer = true
			active_customer.emit(desired_music)
	
	elif exit_store:
		
		var target_position = Vector2(-120,285)
		var speed = 400
		var direction = (target_position-position).normalized()
			
		position += direction * speed * delta
			
		if position.distance_to(target_position) < Main.threshold:
			$".".queue_free()
			change_customer.emit()
	
	elif current_customer:
		Main.characters = desired_music
		$Timer.value = $Timer/time_left.time_left
		$Timer/RichTextLabel.text = str($Timer.value).pad_decimals(2)
		if !timer_started && hint_played:
			$Timer/time_left.start()
			timer_started = true
	

func _on_time_left_timeout() -> void:
	lost_customer.emit()
	Main.lives-=1
	exit_store = true
	$Timer.queue_free()
	change_customer.emit()


func _on_main_move_customer_2() -> void:
	enter_store = true


func _on_main_move_customer_3() -> void:
	moving = true


func _on_hint_1_finished() -> void:
	hint_played = true



func _on_play_hint_pressed() -> void:
	if first_hint_active:
		$"PlayHint/Hint 1".play()
	elif second_hint_active:
		$"PlayHint/Hint 2".play()


func _on_main_points_changed(points) -> void:
	if current_customer && points_on_change != points:
		points_on_change = points
		exit_store = true
		$Timer.queue_free()
		current_customer = false
		$Neutral.visible = false
		$Angry.visible = false
		$Won.visible = true
		change_customer.emit()


func _on_main_two_times_changed(two_times) -> void:
	if current_customer:
		if two_times == 2 && !two_times_changed:
			first_hint_active = true
		elif two_times == 1:

			two_times_changed = true
			first_hint_active = true
			$Neutral.visible = false
			$Angry.visible = true
			$Failed.visible = false
		elif two_times == 2 && two_times_changed:
			print_debug(two_times)
			exit_store = true
			$Timer.queue_free()
			two_times_changed = false
			current_customer = false
			$Neutral.visible = false
			$Angry.visible = false
			$Failed.visible = true
			change_customer.emit()
		else:
			pass
