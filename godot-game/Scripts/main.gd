extends Node2D


var points=0
		
var lives=3
		
var two_times=2
		
var threshold = 6
var characters=8
var curr_customer = 0

var two_times_tracker = 2:
	get:
		return two_times_tracker
	set(new_two_times):
		two_times_changed.emit(new_two_times)
		
var lives_tracker = 3:
	get:
		return lives_tracker
	set(new_lives):
		lives_changed.emit(new_lives)

var points_tracker = 0:
	get:
		return points_tracker
	set(new_points):
		points_changed.emit(new_points)

var hearts_is_2:bool = false
var hearts_is_1:bool = false
var hearts_is_0:bool = false

signal lives_changed
signal points_changed
signal two_times_changed
signal move_customer_1
signal move_customer_2
signal move_customer_3
signal move_customer_4

func _process(delta: float) -> void:
	two_times_tracker = Main.two_times
	lives_tracker = Main.lives
	points_tracker = Main.points

func _on_customer_change_customer() -> void:
	print_debug("lives = " + str(lives))
	move_customer_1.emit()
	print_debug("two_times = " + str(two_times))


func _on_customer_3_change_customer() -> void:
	print_debug("lives = " + str(lives))
	move_customer_4.emit()


func _on_customer_4_change_customer() -> void:
	print_debug("lives = " + str(lives))
	pass # Replace with function body.
	#TODO Special case when the day ends


func _on_customer_1_change_customer() -> void:
	print_debug("lives = " + str(lives))
	move_customer_2.emit()


func _on_customer_2_change_customer() -> void:
	print_debug("lives = " + str(lives))
	move_customer_3.emit()


func _on_customer_lost_customer() -> void:
	lives -= 1


func _on_customer_1_lost_customer() -> void:
	lives -= 1


func _on_customer_2_lost_customer() -> void:
	lives -= 1


func _on_customer_3_lost_customer() -> void:
	lives -= 1


func _on_customer_4_lost_customer() -> void:
	lives -= 1


func _on_lives_changed(new_lives) -> void:
	if new_lives == 2 && !hearts_is_2:
		$Heart3.queue_free()
		hearts_is_2 = true
	elif new_lives == 1 && !hearts_is_1:
		$Heart2.queue_free()
		hearts_is_1 = true
	elif new_lives == 0 && !hearts_is_0:
		$Heart.queue_free()
		hearts_is_0 = true


func _on_customer_active_customer(preferred_music) -> void:
	characters = preferred_music
	curr_customer = 0


func _on_customer_1_active_customer(preferred_music) -> void:
	characters = preferred_music
	curr_customer = 1


func _on_customer_2_active_customer(preferred_music) -> void:
	characters = preferred_music
	curr_customer = 2

func _on_customer_3_active_customer(preferred_music) -> void:
	characters = preferred_music
	curr_customer = 3


func _on_customer_4_active_customer(preferred_music) -> void:
	characters = preferred_music
	curr_customer = 4
