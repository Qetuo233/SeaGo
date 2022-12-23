extends Node2D

signal on_piece_put_handled()

var blue_piece_0 = preload("res://actors/blue_piece_0.tscn")
var green_piece_0 = preload("res://actors/green_piece_0.tscn")
var yellow_piece_0 = preload("res://actors/yellow_piece_0.tscn")

var blue_piece_1 = preload("res://actors/blue_piece_1.tscn")
var green_piece_1 = preload("res://actors/green_piece_1.tscn")
var yellow_piece_1 = preload("res://actors/yellow_piece_1.tscn")

var piece_type_set = [\
	[blue_piece_0, green_piece_0, yellow_piece_0],
	[blue_piece_1, green_piece_1, yellow_piece_1] 
]

var piece_type_to_string = ["blue", "green", "yellow"]


var cell_size = 80
var rows = 9
var cols = 14

var cont = preload("res://actors/container.tscn")

var select_grid_locked = false
var extra_select_grid_status = "no"
var pre_grid_pos
var extra_select_grid_pos = Vector2(0, 0)

func _ready():
	for j in range(0, rows):
		for i in range(0, cols):
			var new_container = cont.instance()
			new_container.set("position", grid_to_tol(Vector2(i, j)))
			new_container.set("grid_pos", Vector2(i, j))
			new_container.name = "container_" + str(i) + "_" + str(j)
			add_child(new_container)
			new_container.connect("on_tile_clicked", self, "tile_click")
			new_container.connect("on_tile_selected", self, "tile_selected")
	pass

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

func get_container_name_by_pos(grid_pos):
	return "container_" + str(int(grid_pos.x)) + "_" + str(int(grid_pos.y))

func lock_select_grid(st = true):
	select_grid_locked = st
	
func tile_click(grid_pos):
	if not Que.is_valid_grid_pos(grid_pos):
		push_error("the grid position is not vaild")
		return
#		lock_select_grid_in_tilemap(true)
	if extra_select_grid_status != "no" and extra_select_grid_pos != Vector2(0, 0):
		InputSignals.emits(InputSignals.signals.Select_grid_pos, \
			[extra_select_grid_pos, is_piece_already_put(extra_select_grid_pos)])
		extra_select_grid_pos = Vector2(0, 0)
	else:
		InputSignals.emits(InputSignals.signals.Select_grid_pos, \
			[grid_pos, is_piece_already_put(grid_pos)])

func tile_selected(grid_pos):
	if not Que.is_valid_grid_pos(grid_pos):
		push_error("the grid position is not vaild")
		return
	on_tile_selected(grid_pos)

func on_tile_selected(grid_pos):
	if extra_select_grid_status == "no" and (not select_grid_locked):
		$select_grid.set("position", grid_to_tol(grid_pos))
		$select_grid.visible = true
		$extra_select_grid.visible = false
	else:
		match(extra_select_grid_status):
			"direction":
				for vec in Que.get_basis_vector(pre_grid_pos):
					if grid_pos == pre_grid_pos + vec:
						extra_select_grid_pos = grid_pos
						$extra_select_grid.set("position", grid_to_tol(grid_pos))
				pass
			"grid_pos":
				$extra_select_grid.set("position", grid_to_tol(grid_pos))
		$extra_select_grid.visible = true
	pass

func update_health(grid_pos, new_health):
	var container = get_node(get_container_name_by_pos(grid_pos))
	for item in container.get_children():
		if "piece" in item.name:
			var lab = item.get_node("health_label")
			lab.set("text", str(new_health))

func is_piece_already_put(grid_pos):
	for item in \
		get_node(get_container_name_by_pos(grid_pos)).get_children():
		if "piece" in item.name:
			return true
	return false

func put_piece_in_stage(select_type, grid_pos):
	var select_container = get_node(get_container_name_by_pos(grid_pos))
	
	var piec = piece_type_set[Que.cur_player_index][select_type].instance()
	select_container.set("piece_type", select_type)
	piec.get_node("health_label").visible = true
	piec.get_node("owner_label").visible = true
	piec.get_node("owner_label").set("text", str(Que.cur_player_index))
	select_container.add_child(piec)

	emit_signal("on_piece_put_handled")

func remove_piece_in_stage(grid_pos):
	
	print("intended remove pos" + str(grid_pos))
	
	var select_container = get_node(get_container_name_by_pos(grid_pos))

	for item in select_container.get_children():
		if item.name == piece_type_to_string[select_container.piece_type] + "_piece":
			var piec = item
			select_container.remove_child(piec)
			select_grid_locked = false
			return
	
	push_error("the piece do not exist in this position")
	return

func move_piece_in_stage(piece_type, grid_pos, movement):
	print("try to move from" + str(grid_pos) + "by" + str(movement))
	
	# animation
	
	if Que.is_valid_grid_pos(grid_pos + movement):
		put_piece_in_stage(piece_type, grid_pos + movement)
		remove_piece_in_stage(grid_pos)
