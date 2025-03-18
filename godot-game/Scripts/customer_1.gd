extends Node2D

var desired_music
var time

var hint

var current_customer:bool = false
#TODO Function that sets the value of the customer

func _ready() -> void:
	desired_music = 3
	time = 60
	hint = "I love the number 3"
	
	$Timer/time_left.wait_time = time
	$Timer/time_left.start()
	$Timer.max_value = time
	$Timer.value = $Timer/time_left.time_left
	
func _process(delta: float) -> void:
	if current_customer:
		$Timer.value = $Timer/time_left.time_left
		$Timer/RichTextLabel.text = str($Timer.value).pad_decimals(2)
	
