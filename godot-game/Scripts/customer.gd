extends Node2D

var desired_music
var time: float

var hint

var current_customer:bool = true
var timer_started:bool = false
var enter_store:bool = false
var exit_store:bool = false

signal change_customer

#TODO Function that sets the value of the customer

func _ready() -> void:
	desired_music = 2
	time = 5
	hint = "I love the number 2"
	$Timer/time_left.wait_time = time
	$Timer.max_value = time
	$Timer.value = time
	
func _process(delta: float) -> void:
	if current_customer:
		$Timer.value = $Timer/time_left.time_left
		$Timer/RichTextLabel.text = str($Timer.value).pad_decimals(2)
		if !timer_started:
			$Timer/time_left.start()
			timer_started = true


func _on_time_left_timeout() -> void:
	
	$".".queue_free()
	change_customer.emit()
