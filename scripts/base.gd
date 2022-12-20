extends Node

func _ready():
	print("scene " + self.name)
	yield(get_tree().create_timer(0.5), "timeout")
	change_scene_entrence()

func change_scene_entrence():
	get_tree().change_scene("res://scenes/entrance.tscn")
	
