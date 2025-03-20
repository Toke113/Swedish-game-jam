extends Node2D

var desired_music
var time

var hint

var current_customer:bool = false
var timer_started:bool = false
var moving:bool = false
var enter_store:bool = false
var exit_store:bool = false
var hint_played:bool = false
var two_times_changed:bool = false

signal change_customer
signal lost_customer
signal active_customer

#TODO Function that sets the value of the customer

func _ready() -> void:
	desired_music = 1
	time = 10
	hint = "I love the number 1"
	Main.characters = desired_music
	
	$Timer/time_left.wait_time = time
	if current_customer:
		$Timer/time_left.start()
	$Timer.max_value = time
	$Timer.value = $Timer/time_left.time_left
	
func _process(delta: float) -> void:
	if enter_store:
		var target_position = Vector2(1730,230)
		var speed = 400

		var direction = (target_position-position).normalized()
			
		position += direction * speed * delta
		
		if position.distance_to(target_position) < Main.threshold:
			enter_store = false
	elif moving:
		var target_position = Vector2(930,360)
		var speed = 400

		var direction = (target_position-position).normalized()
			
		position += direction * speed * delta
		
		if position.distance_to(target_position) < Main.threshold:
			moving = false
			current_customer = true
			active_customer.emit(desired_music)
	
	elif exit_store:
		
		var target_position = Vector2(-485,285)
		var speed = 400
		var direction = (target_position-position).normalized()
			
		position += direction * speed * delta
			
		if position.distance_to(target_position) < Main.threshold:
			$".".queue_free()
			change_customer.emit()
	
	elif current_customer:
		$Timer.value = $Timer/time_left.time_left
		$Timer/RichTextLabel.text = str($Timer.value).pad_decimals(2)
		if !timer_started && hint_played:
			$Timer/time_left.start()
			timer_started = true
	

func _on_time_left_timeout() -> void:
	lost_customer.emit()
	exit_store = true
	$Timer.queue_free()
	change_customer.emit()


func _on_main_move_customer_1() -> void:
	enter_store = true


func _on_main_move_customer_2() -> void:
	moving = true


func _on_hint_1_finished() -> void:
	hint_played = true


func _on_play_hint_pressed() -> void:
	hint_played = true
	pass # Replace with function body.


func _on_main_points_changed() -> void:
	if current_customer:
		exit_store = true
		$Timer.queue_free()
		change_customer.emit()


func _on_main_two_times_changed(two_times) -> void:
	if current_customer:
		if two_times == 2 && !two_times_changed:
			pass
		elif two_times == 1:
			
			two_times_changed = true
			pass #change hint
		elif two_times == 2 && two_times_changed:
			print_debug(two_times)
			exit_store = true
			$Timer.queue_free()
			two_times_changed = false
			change_customer.emit()
		else:
			pass
