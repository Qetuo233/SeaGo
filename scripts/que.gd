extends Node

onready var ROW = 9
onready var COL = 14
onready var player1 : Player = Player.new()
onready var player2 : Player = Player.new()
onready var players = [player1, player2]
onready var cur_player_index = -1
onready var piece_cost_energy = [5, 3, 4]
onready var action_cost_energy = 1
onready var piece_health = [1, 2, 4]

func _ready():
	randomize()

func is_valid_grid_pos(grid_pos):
	return grid_pos.x >= 0 and grid_pos.x < COL and \
		grid_pos.y >= 0 and grid_pos.y < ROW

func get_basis_vector(grid_pos):
	var y = int(grid_pos.y)
	
	if y % 2 == 0:
		return [
			Vector2(1, 0), Vector2(0, -1), Vector2(-1, -1),
			Vector2(-1, 0), Vector2(-1, 1), Vector2(0, 1)
		]
	else:
		return [
			Vector2(1, 0), Vector2(1, -1), Vector2(0, -1),
			Vector2(-1, 0), Vector2(0, 1), Vector2(1, 1)
		]

func get_cur_player():
	return players[cur_player_index]

func get_against_player():
	return players[1 - cur_player_index]

func reset_players(round_index):
	if round_index > 1:
		player1.energy += 12
		player2.energy += 12
		player1.pieces_num[randi() % 3] += 1
		player2.pieces_num[randi() % 3] += 1
	else:
		player1.energy = 8
		player1.pieces_num = [1, 1, 1]
		player1.score = 0
		player2.energy = 14
		player2.pieces_num = [1, 1, 1]
		player2.score = 0

func remove_piece(pos):
	pass

func end_cur_player_turn():
	get_cur_player().state = TurnBasedPlayer.State.Submitted

func check_event(cost_energy):
	var cur_palyer = get_cur_player()
	return cur_palyer.energy >= cost_energy

func do_event(cost_energy):
	var cur_palyer = get_cur_player()
	if cur_palyer.energy >= cost_energy:
		cur_palyer.energy -= cost_energy
		return true
	return false
##func is_tap_event(event: InputEvent):
#	if event is InputEventMouseButton:
#		if event.button_index == 1 and event.pressed == true:
#			return true
#	return false
