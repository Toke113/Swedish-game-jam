extends Node2D


var points=0:
	get:
		return points
	set(new_points):
		points_changed.emit()
		points = new_points
		
var lives=3:
	get:
		return lives
	set(new_lives):
		lives_changed.emit()
		lives = new_lives
		
var two_times=2:
	get:
		return two_times
	set(new_two_times):
		two_times_changed.emit(new_two_times)
		two_times = new_two_times
		
var threshold = 6
var characters=1
var curr_customer = 0

signal lives_changed
signal points_changed
signal two_times_changed
signal move_customer_1
signal move_customer_2
signal move_customer_3
signal move_customer_4


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


func _on_lives_changed() -> void:
	print_debug("lives")
	if lives == 2:
		$Heart3.queue_free()
	elif lives == 1:
		$Heart2.queue_free()
	elif lives == 0:
		$Heart.queue_free()


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
