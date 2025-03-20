extends Node2D

var desired_music
var time

var hint

var current_customer:bool = false
var timer_started:bool = false
var moving:bool = false
var enter_store:bool = false
var exit_store:bool = false

signal change_customer

#TODO Function that sets the value of the customer

func _ready() -> void:
	desired_music = 5
	time = 2
	hint = "I love the number 5"
	
	$Timer/time_left.wait_time = time
	if current_customer:
		$Timer/time_left.start()
	$Timer.max_value = time
	$Timer.value = $Timer/time_left.time_left
	
func _process(delta: float) -> void:
	if enter_store:
		var target_position = Vector2(1900,70)
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
		if !timer_started:
			$Timer/time_left.start()
			timer_started = true
	

func _on_time_left_timeout() -> void:
	exit_store = true
	$Timer.queue_free()
	change_customer.emit()


func _on_main_move_customer_2() -> void:
	enter_store = true


func _on_main_move_customer_3() -> void:
	moving = true
