extends Node2D


var points=0
var lives=3
var two_times=2

var  characters=1


signal move_customer_1
signal move_customer_2
signal move_customer_3
signal move_customer_4

#TODO call the character creator function


func _on_customer_change_customer() -> void:
	$customer_1.transform
	print_debug("debooger")	
	characters += 1


func _on_customer_1_change_customer() -> void:
	pass # Replace with function body.


func _on_customer_2_change_customer() -> void:
	pass # Replace with function body.


func _on_customer_3_change_customer() -> void:
	pass # Replace with function body.


func _on_customer_4_change_customer() -> void:
	pass # Replace with function body.
