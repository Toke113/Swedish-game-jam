extends Node2D

func play():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
func close():
	get_tree().quit()
