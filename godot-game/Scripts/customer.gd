extends Node2D

var desired_music
var time: float

var hint

var current_customer:bool = true
var timer_started:bool = false
var enter_store:bool = false
var exit_store:bool = false
var hint_played:bool = false

signal change_customer
signal lost_customer

#TODO Function that sets the value of the customer

func _ready() -> void:
	desired_music = 2
	time = 5
	hint = "I love the number 2"
	$Timer/time_left.wait_time = time
	$Timer.max_value = time
	$Timer.value = time
	
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
	hint_played = true
	pass # Replace with function body.
