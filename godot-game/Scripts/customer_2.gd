extends Node2D

var desired_music
var time

var hint

var current_customer:bool = false
var timer_started:bool = false
#TODO Function that sets the value of the customer

func _ready() -> void:
	desired_music = 1
	time = 50
	hint = "I love the number 1"
	
	$Timer/time_left.wait_time = time
	if current_customer:
		$Timer/time_left.start()
	$Timer/time_left.start()
	$Timer.max_value = time
	$Timer.value = $Timer/time_left.time_left
	
func _process(delta: float) -> void:
	if current_customer:
		$Timer.value = $Timer/time_left.time_left
		$Timer/RichTextLabel.text = str($Timer.value).pad_decimals(2)
		if !timer_started:
			$Timer/time_left.start()
			timer_started = true
