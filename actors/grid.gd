extends TileMap

signal grid_clicked(pos)

func _ready():
	pass

#func oddrow_to_cube(tile):
#	var col = int(tile.x)
#	var row = int(tile.y)
#	var x = int(col - (row - (row & 1)) / 2)
#	var z = row
#	var y = - x - z
#	return Vector3(x, y, z)
#
#func cube_to_oddrow(cube):
#	var x = int(cube.x)
#	var z= int(cube.z)
#	var col = int(x + (z - (z & 1)) / 2)
#	var row = z
#	return Vector2(col, row)


#func _unhandled_input(event):
#	if Que.is_tap_event(event):
#		var cur_mouse_pos_in_stage = .get_global_mouse_position() + Vector2(-220, 0)
#		var grid_pos = .world_to_map(cur_mouse_pos_in_stage)
#		emit_signal("grid_clicked", grid_pos)
#		print("mouse:" + str(cur_mouse_pos_in_stage))
#		print(grid_pos)
