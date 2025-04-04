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
	desired_music = 9

	time = 100
	hint = "I love the number 3"
	
	$Timer/time_left.wait_time = time
	if current_customer:
		$Timer/time_left.start()
	$Timer.max_value = time
	$Timer.value = $Timer/time_left.time_left
	
func _process(delta: float) -> void:
	
	if moving:
		points_on_change = Main.points
		var target_position = Vector2(880,520)
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

	
	elif current_customer:
		Main.characters = desired_music
		print_debug(Main.characters)
		$Timer.value = $Timer/time_left.time_left
		$Timer/RichTextLabel.text = str($Timer.value).pad_decimals(2)
		if !timer_started && hint_played:
			$Timer/time_left.start()
			timer_started = true
		
	
	

func _on_time_left_timeout() -> void:
	lost_customer.emit()
	Main.lives-=1
	exit_store = true
	#$Timer.queue_free()
	change_customer.emit()

func _on_main_move_customer_1() -> void:
	print_debug("Custoemr 1 is moving")
	moving = true


func _on_hint_1_finished() -> void:
	hint_played = true


func _on_play_hint_pressed() -> void:
	if first_hint_active:
		$"PlayHint/Hint 1".play()
	elif second_hint_active:
		$"PlayHint/Hint 2".play()
	pass # Replace with function body.


func _on_main_points_changed(points) -> void:
	if current_customer && points_on_change != points:
		points_on_change = points
		exit_store = true
		$Timer.queue_free()
		current_customer = false
		$ChildNeutral.visible = false
		$ChildAngry.visible = false
		$ChildWon.visible = true
		change_customer.emit()


func _on_main_two_times_changed(two_times) -> void:
	if current_customer:
		if two_times == 2 && !two_times_changed:
			first_hint_active = true
		elif two_times == 1:

			two_times_changed = true
			first_hint_active = false
			second_hint_active = true
			$ChildNeutral.visible = false
			$ChildAngry.visible = true
			$ChildFailed.visible = false
		elif two_times == 2 && two_times_changed:
			print_debug(two_times)
			exit_store = true
			$Timer.queue_free()
			two_times_changed = false
			current_customer = false
			$ChildNeutral.visible = false
			$ChildAngry.visible = false
			$ChildFailed.visible = true
			change_customer.emit()
		else:
			pass
