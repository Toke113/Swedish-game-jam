extends Node2D

var desired_music
var time: float

var hint
var points_on_change

var current_customer:bool = true
var timer_started:bool = false
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
	desired_music = 2
	time = 10
	hint = "I love the number 2"
	points_on_change = 0
	$Timer/time_left.wait_time = time
	$Timer.max_value = time
	$Timer.value = time
	active_customer.emit(desired_music)

	
func _process(delta: float) -> void:
	if exit_store:
		
		var target_position = Vector2(-485,285)
		var speed = 400
		var direction = (target_position-position).normalized()
			
		position += direction * speed * delta
			
		if position.distance_to(target_position) < Main.threshold:
			$".".queue_free()

	
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


func _on_hint_1_finished() -> void:
	hint_played = true


func _on_play_hint_pressed() -> void:
	if first_hint_active:
		$"PlayHint/Hint 1".play()
	elif second_hint_active:
		$"PlayHint/Hint 2".play()
	pass # Replace with function body.


func _on_main_points_changed(points) -> void:
	if current_customer && points != points_on_change:
		points_on_change = points
		exit_store = true
		current_customer = false
		$FunkyNeutral.visible = false
		$FunkyAngry.visible = false
		$FunkyFailed.visible = false
		$FunkyWon.visible = true
		$Timer.queue_free()
		change_customer.emit()


func _on_main_two_times_changed(two_times) -> void:
	if current_customer:
		if two_times == 2 && !two_times_changed:
			first_hint_active = true
		elif two_times == 1:
			
			two_times_changed = true
			first_hint_active = false
			second_hint_active = true
			$FunkyNeutral.visible = false
			$FunkyAngry.visible = true
			$FunkyFailed.visible = false
			$FunkyWon.visible = false
		elif two_times == 2 && two_times_changed:
			print_debug(two_times)
			exit_store = true
			$Timer.queue_free()
			two_times_changed = false
			current_customer = false
			$FunkyNeutral.visible = false
			$FunkyAngry.visible = false
			$FunkyFailed.visible = true
			$FunkyWon.visible = false
			change_customer.emit()
		else:
			pass
		
