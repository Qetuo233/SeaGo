extends Node

signal input_signal(signal_type, data)

enum signals {
	Select_grid_pos, Select_piece_choice, Select_skill, End_turn, Empty
}
const Select_grid_pos = "select_grid_pos"
const Select_piece_choice = "select_piece_choice"
const Select_skill = "select_skill"
const End_turn = "end_turn"
const Empty = "empty"

func emits(signal_type, data):
	emit_signal("input_signal", signal_type, data)
