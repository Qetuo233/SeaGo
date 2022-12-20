extends Node2D


var cur_select_grid_pos = -1

func _ready():
	pass

func enable_select_indicator(type):
	$select_indicator.position = Vector2(70, 0) * type
	$select_indicator.visible = true

func disable_select_indicator():
	$select_indicator.visible = false




func _on_blue_piece_pre_selected():
	if cur_select_grid_pos != 0:
		cur_select_grid_pos = 0
		enable_select_indicator(cur_select_grid_pos)


func _on_yellow_piece_pre_selected():
	if cur_select_grid_pos != 2:
		cur_select_grid_pos = 2
		enable_select_indicator(cur_select_grid_pos)


func _on_green_piece_pre_selected():
	if cur_select_grid_pos != 1:
		cur_select_grid_pos = 1
		enable_select_indicator(cur_select_grid_pos)


func _on_blue_piece_selected(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		if not get_tree().is_input_handled():
			InputSignals.emits(InputSignals.signals.Select_piece_choice, [0])

func _on_green_piece_selected(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		if not get_tree().is_input_handled():
			InputSignals.emits(InputSignals.signals.Select_piece_choice, [1])

func _on_yellow_piece_selected(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		if not get_tree().is_input_handled():
			InputSignals.emits(InputSignals.signals.Select_piece_choice, [2])
