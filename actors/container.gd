extends Node2D

onready var grid_pos
onready var piece_type = -1

signal on_tile_clicked(pos)
signal on_tile_selected(pos)


func _ready():
	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		if not get_tree().is_input_handled():
			emit_signal("on_tile_clicked", grid_pos)
	# No screen touch


func _on_Area2D_mouse_entered():
	emit_signal("on_tile_selected", grid_pos)
