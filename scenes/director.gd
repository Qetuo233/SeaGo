extends Node

signal unlock_extra_select_indicator

signal move_piece_in_stage(grid_pos, movement)

signal remove_piece_in_stage(grid_pos)

var cur_player
var against_player

func _ready():
	pass

var cell_size = 80
var rows = 9
var cols = 14

func grid_to_tol(grid_pos):
	var cur_col = int(grid_pos.x)
	var cur_row = int(grid_pos.y)
	var offset = Vector2(0, -12)
	if cur_row % 2 == 0:
		return offset + Vector2(cur_col * cell_size + cell_size * 0.5, \
			cur_row * cell_size + cell_size * 0.5 )
	else:
		return offset + Vector2((cur_col + 1) * cell_size, \
			cur_row * cell_size + cell_size * 0.5)

func start_round(index):
	Infos.refresh_round_info(index)
	ready_for_round(index)


func ready_for_round(index):
	Que.reset_players(index)
	Infos.refresh_player_info()

func start_turn():
	cur_player = Que.get_cur_player()
	against_player = Que.get_against_player()
	Infos.refresh_messager_info("new_player", \
		[Que.cur_player_index, Que.get_cur_player().pname])
	pass

func in_own_field(index, grid_pos):
	if index == 0:
		return grid_pos.x <= 5
	else:
		return grid_pos.x >= 8

func belong_to(grid_pos):
	for idx in range(2):
		for piec in Que.players[idx].possession:
			if piec.position == grid_pos:
				return idx
	return -1

func check_skill(input_data, extra_input = false):
	var extra_input_status = false
	
	var type = cur_player.get_piece_type_by_pos(select_grid_pos)
	
	var cont = get_parent().get_node("stage/containers")
	
	if not extra_input:
		select_skill_type = input_data[0]
		select_grid_pos = input_data[1]
	
	match(type):
		0:
			match(select_skill_type):
				0:
					if not Que.check_event(Que.action_cost_energy):
						Infos.refresh_messager_info("action_failed", \
							["throw", str(select_grid_pos), "do not have energy"])
						return false
					if not try_throw_piece_for_player(select_grid_pos, true):
						Infos.refresh_messager_info("action_failed", \
							["throw", str(select_grid_pos), "piece do not exist"])
						return false
					return true
				1:
					if not Que.check_event(Que.action_cost_energy):
						Infos.refresh_messager_info("action_failed", \
							["skill1", str(select_grid_pos), "do not have energy"])
						return false
					var cur_piece = cur_player.possession[\
						cur_player.find_piece_idx_in_possession_by_pos(select_grid_pos)]
					if not cur_piece.movable:
						Infos.refresh_messager_info("action_failed", \
							["skill1", str(select_grid_pos), "piece cannot move"])
						return false
					var vec = input_data[0]
					var length = 1
					if not is_crossed(length, select_grid_pos, vec - select_grid_pos):
						Infos.refresh_messager_info("action_failed", \
							["skill1", str(select_grid_pos), "other piece exists"])
						return false
					return true
				2:
					if not Que.check_event(Que.action_cost_energy):
						Infos.refresh_messager_info("action_failed", \
							["skill2", str(select_grid_pos), "do not have energy"])
						return false
					return true
		1:
			match(select_skill_type):
				0:
					if not Que.check_event(Que.action_cost_energy):
						Infos.refresh_messager_info("action_failed", \
							["throw", str(select_grid_pos), "do not have energy"])
						return false
					if not try_throw_piece_for_player(select_grid_pos, true):
						Infos.refresh_messager_info("action_failed", \
							["throw", str(select_grid_pos), "piece do not exist"])
						return false
					return true
				1:
					if not Que.check_event(Que.action_cost_energy):
						Infos.refresh_messager_info("action_failed", \
							["skill1", str(select_grid_pos), "do not have energy"])
						return false
					var cur_piece = cur_player.possession[\
						cur_player.find_piece_idx_in_possession_by_pos(select_grid_pos)]
					if not cur_piece.movable:
						Infos.refresh_messager_info("action_failed", \
							["skill1", str(select_grid_pos), "piece cannot move"])
						return false
					var vec = input_data[0]
					var length = 3
					if not is_crossed(length, select_grid_pos, vec - select_grid_pos):
						Infos.refresh_messager_info("action_failed", \
							["skill1", str(select_grid_pos), "other piece exists"])
						return false
					return true
				2:
					if not Que.check_event(Que.action_cost_energy):
						Infos.refresh_messager_info("action_failed", \
							["skill2", str(select_grid_pos), "do not have energy"])
						return false
					return true
		2:
			match(select_skill_type):
				0:
					if not Que.check_event(Que.action_cost_energy):
						Infos.refresh_messager_info("action_failed", \
							["throw", str(select_grid_pos), "do not have energy"])
						return false
					if not try_throw_piece_for_player(select_grid_pos, true):
						Infos.refresh_messager_info("action_failed", \
							["throw", str(select_grid_pos), "piece do not exist"])
						return false
					return true
				1:
					if not Que.check_event(Que.action_cost_energy):
						Infos.refresh_messager_info("action_failed", \
							["skill1", str(select_grid_pos), "do not have energy"])
						return false
					return true
				2:
					if not Que.check_event(Que.action_cost_energy):
						Infos.refresh_messager_info("action_failed", \
							["skill1", str(select_grid_pos), "do not have energy"])
						return false
					return true

func check_put(type, grid_pos):
	if not in_own_field(Que.cur_player_index, grid_pos):
		Infos.refresh_messager_info("action_failed", \
			["put", str(grid_pos), "not own field"])
		return false
	if not Que.get_cur_player().pieces_num[type] > 0:
		Infos.refresh_messager_info("action_failed", \
			["put", str(grid_pos), "do not have this piece"])
		return false
	if not Que.check_event(Que.piece_cost_energy[type]):
		Infos.refresh_messager_info("action_failed", \
			["put", str(grid_pos), "do not have energy"])
		return false
	return true

func put_piece_for_player(type, grid_pos):
	Que.do_event(Que.piece_cost_energy[type])
	cur_player.move_piece_to_possession(type, grid_pos)
	pass

func try_throw_piece_for_player(grid_pos, just_try=true):
	return cur_player.try_throw_piece_from_possession(grid_pos, just_try)

func move_piece_for_player(grid_pos, movement):
	cur_player.move_piece(grid_pos, movement)

func get_piece_attacked_for_player(player, grid_pos, demage):
	player.get_piece_attacked(grid_pos, demage)

func check_for_died_piece():
	for player_index in range(2):
		for piec in Que.players[player_index].possession:
			if piec.health <= 0:
				emit_signal("remove_piece_in_stage", piec.position)

func extra_input_for_skill(skill_type, grid_pos):
	var idx = cur_player.find_piece_idx_in_possession_by_pos(grid_pos)
	var type = cur_player.possession[idx].type
	
	if type == 0:
		return "direction"
	if type == 1 and skill_type == 1:
		return "direction"
	if type == 2 and (skill_type == 1 or skill_type == 2):
		return "direction"
	return "no"


var select_skill_type
var select_grid_pos

func pre_use_skill(skill_type, grid_pos):
	select_skill_type = skill_type
	select_grid_pos = grid_pos

func is_crossed(length, start_pos, first_step):
	var vec_index = -1
	for idx in range(6):
		var v = Que.get_basis_vector(start_pos)[idx]
		if v == first_step:
			vec_index = idx
			break
	var movement = Vector2(0, 0)
	var cur_pos = start_pos
	
	for step in range(length):
		movement += Que.get_basis_vector(cur_pos)[vec_index]
		cur_pos = start_pos + movement
		print("cur_pos = " + str(cur_pos))
		for player in Que.players:
			for piec in player.possession:
				if piec.position == cur_pos:
					return false
	return true

func get_movement(length, start_pos, first_step):
	var vec_index = -1
	for idx in range(6):
		var v = Que.get_basis_vector(start_pos)[idx]
		if v == first_step:
			vec_index = idx
			break
	var movement = Vector2(0, 0)
	var cur_pos = start_pos
	for step in range(length):
		movement += Que.get_basis_vector(cur_pos)[vec_index]
		cur_pos = start_pos + movement
	return movement

func get_data_from_extra_input(input_data):
	var vec = input_data[0]
	match(extra_input_for_skill(select_skill_type, select_grid_pos)):
		"direction":
#			var r = grid_to_tol(vec) - grid_to_tol(select_grid_pos)
			var length = 1
			var piece_type = cur_player.get_piece_type_by_pos(select_grid_pos)
			if select_skill_type == 1 and piece_type == 1:
				length = 3
			if (select_skill_type == 1 or select_skill_type == 2) \
				and piece_type == 2:
				length = 2
#			print(length)
			return get_movement(length, select_grid_pos, vec - select_grid_pos)
		"grid_pos":
			return vec
	pass

func use_skill(input_data, extra_input = false):
	if extra_input:
		var temp = get_data_from_extra_input(input_data)
		input_data = [select_skill_type, select_grid_pos, \
			temp, input_data[0]]
	else:
		select_skill_type = input_data[0]
		select_grid_pos = input_data[1]
	
	var type = cur_player.get_piece_type_by_pos(select_grid_pos)
	
	var cont = get_parent().get_node("stage/containers")
	
	match(type):
		0:
			match(select_skill_type):
				0:
					var dir = input_data[2]
					try_throw_piece_for_player(select_grid_pos, false)
					cont.remove_piece_in_stage(select_grid_pos)
					
					shoot_for_player(select_grid_pos, dir, 2)
					
					for vec in Que.get_basis_vector(select_grid_pos):
						if vec != dir:
							shoot_for_player(select_grid_pos, vec, 1)
				1:
					var movement = input_data[2]
					move_piece_for_player(select_grid_pos, movement)
					cont.move_piece_in_stage( \
						type, select_grid_pos, movement)
				2:
					var dir = input_data[2]
	
					shoot_for_player(select_grid_pos, dir, 1)
		1:
			match(select_skill_type):
				0:
					try_throw_piece_for_player(select_grid_pos, false)
					cont.remove_piece_in_stage(select_grid_pos)
					cur_player.heal_all_piece()
				1:
					var movement = input_data[2]
					move_piece_for_player(select_grid_pos, movement)
					cont.move_piece_in_stage(\
						type, select_grid_pos, movement)
				2:
					for pos in get_nearby_pos(select_grid_pos):
						var cur_player_idx = cur_player.find_piece_idx_in_possession_by_pos(pos)
						var against_player_idx = against_player.find_piece_idx_in_possession_by_pos(pos)
						if cur_player_idx != -1:
							var piec = cur_player.possession[cur_player_idx]
							if piec.health + 1 <= Que.piece_health[piec.type]:
								piec.health += 1
						elif against_player_idx != -1:
							var piec = against_player.possession[against_player_idx]
							piec.movable = false
		2:
			match(select_skill_type):
				0:
					for pos in get_nearby_pos(select_grid_pos):
						get_piece_attacked_for_player(against_player, pos, 3)
				1:
					var movement = input_data[2]
					shoot_for_player(select_grid_pos, input_data[3] - select_grid_pos, 2, 100)
					move_piece_for_player(select_grid_pos, movement)
					cont.move_piece_in_stage( \
						type, select_grid_pos, movement)
				2:
					var movement = input_data[2]
					shoot_for_player(select_grid_pos, input_data[3] - select_grid_pos, 2, 100)
					move_piece_for_player(select_grid_pos, movement)
					cont.move_piece_in_stage( \
						type, select_grid_pos, movement)
	check_for_died_piece()
	Que.do_event(Que.action_cost_energy)

func get_nearby_pos(grid_pos):
	# radius = 2
	var ret_list = [grid_pos]
	for e1 in Que.get_basis_vector(grid_pos):
		var pos_in_one_step = grid_pos + e1
		if ret_list.find(pos_in_one_step) == -1 and \
			Que.is_valid_grid_pos(pos_in_one_step):
			ret_list.append(pos_in_one_step)
		for e2 in Que.get_basis_vector(pos_in_one_step):
			var pos_in_two_step = pos_in_one_step + e2
			if ret_list.find(pos_in_two_step) == -1 and \
			Que.is_valid_grid_pos(pos_in_two_step):
				ret_list.append(pos_in_two_step)
	return ret_list

func shoot_for_player(grid_pos, direction, demage, step_limit=3):
	print("shoot! from" + str(grid_pos))
	var cur_pos = grid_pos + direction
	var steps = 1
	while Que.is_valid_grid_pos(cur_pos) and \
		(in_own_field(Que.cur_player_index, cur_pos) or steps <= step_limit):
		print("bullet" + str(cur_pos))
		if against_player.find_piece_idx_in_possession_by_pos(cur_pos) != -1:
			get_piece_attacked_for_player(against_player, cur_pos, demage)
			return true
		cur_pos += direction
		steps += 1
	return false

func end_turn():
	Que.end_cur_player_turn()


