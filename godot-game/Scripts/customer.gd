extends Node2D

var desired_music
var time: float

var hint

var current_customer:bool = true

#TODO Function that sets the value of the customer

func _ready() -> void:
	desired_music = 2
	time = 90
	hint = "I love the number 2"
	$Timer/time_left.wait_time = time
	$Timer/time_left.start()
	$Timer.max_value = time
	$Timer.value = $Timer/time_left.time_left
	
func _process(delta: float) -> void:
	if current_customer:
		$Timer.value = $Timer/time_left.time_left
		$Timer/RichTextLabel.text = str($Timer.value).pad_decimals(2)
	
