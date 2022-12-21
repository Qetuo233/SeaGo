extends TurnBasedPlayer

class_name Player

var pname = ""
var score = 0 setget set_score
var energy = 0 setget set_energy
var pieces_num = [0, 0, 0]
var possession = []
var is_in_vision = []

func _ready():
	for i in range(Que.COL):
		var cur_col = []
		for j in range(Que.ROW):
			cur_col.append(false)
		is_in_vision.append(cur_col)
	pass

func set_score(v):
	score = v
	Infos.refresh_player_info()

func set_energy(v):
	energy = v
	Infos.refresh_player_info()

func refresh_possession(index):
	var l_bound
	if index == 0:
		l_bound = 0
	else:
		l_bound = 8
	for i in range(l_bound, l_bound + Que.COL / 2):
		for j in range(Que.ROW):
			add_pos_to_vision(Vector2(i, j))
	for piec in possession:
		if piec.health <= 0:
			possession.erase(piec)
			Que.remove_piece(piec.position)

func move_piece_to_possession(type, pos):
	var new_piece = piece.new()
	new_piece.position = pos
	new_piece.type = type
	new_piece.health = Que.piece_health[type]
	new_piece.movable = true
	new_piece.attackable = true
	possession.append(new_piece)
	pieces_num[type] -= 1

func add_pos_to_vision(pos):
	is_in_vision[int(pos.x)][int(pos.y)] = true

func del_pos_from_vision(pos):
	is_in_vision[int(pos.x)][int(pos.y)] = false

func get_all_health():
	var ret = []
	for piec in possession:
		ret.append([piec.position, piec.health])
	return ret

func find_piece_idx_in_possession_by_pos(pos):
	for idx in range(len(possession)):
		var piec = possession[idx]
		if piec.position == pos:
			return idx
	return -1

func get_piece_type_by_pos(pos):
	var idx = find_piece_idx_in_possession_by_pos(pos)
	return possession[idx].type

func try_throw_piece_from_possession(pos,just_try=false):
	var idx = find_piece_idx_in_possession_by_pos(pos)
	if idx != -1:
		if not just_try:
			possession.remove(idx)
		return true
	return false

func move_piece(pos, movement):
	var idx = find_piece_idx_in_possession_by_pos(pos)
	if idx != -1:
		if possession[idx].movable == true:
			possession[idx].position += movement
			return true
	return false

func get_piece_attacked(pos, demage):
	var idx = find_piece_idx_in_possession_by_pos(pos)
	if idx != -1:
		if possession[idx].attackable == true:
			possession[idx].health -= demage
	return false

func heal_all_piece():
	for item in possession:
		item.health = Que.piece_health[item.type]
