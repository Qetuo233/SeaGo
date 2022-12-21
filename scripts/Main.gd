extends Node2D


func _ready():
	$turn_based_director.pre_play()
	$turn_based_director.play()
	pass

func get_name_from_grid_pos(grid_pos):
	return "container_" + str(grid_pos.x) + "_" + str(grid_pos.y)

var stage_playing = true
var first_select = true
var last_click_event_handled = true

#func play():
#	stage_playing = true
#	while stage_playing:
#		var buf = yield($stage/containers, "on_container_clicked")
#		var grid_pos = buf[0]
#		var container_status = buf[1]
#		if first_select:
#			$stage/containers.lock_select_grid()
#			if container_status == false:
#				$HUD/left_panel.disable_action_button()
#				$HUD/left_panel.enanble_choice_node()
#
#				var select_piece_type = yield($HUD/left_panel/choice_node, \
#					"on_piece_type_selected")
#				var handled = $director.check_put(select_piece_type, grid_pos)
#
#				if handled:
#					$director.put_piece_for_player(select_piece_type, grid_pos)
#					$stage/containers.put_piece_in_stage(select_piece_type, grid_pos)
#
#					Infos.refresh_player_info()
#					Infos.refresh_messager_info("action_succeed", \
#						["put", str(grid_pos)])
#
#				$HUD/left_panel.disable_choice_node()
#			else:
#				$HUD/left_panel.enable_action_button()
#				$HUD/left_panel.disable_choice_node()
#
#				var select_skill_type = yield($HUD/left_panel/action_buttons,\
#					"on_skill_selected")
#				var handled = $director.check_skill(select_skill_type, grid_pos)
#				if handled:
#					var extra_input = $director.extra_input_for_skill(select_skill_type, grid_pos)
#					match(extra_input):
#						"direction":
#							pass
#						"grid_pos":
#							pass
#						"no":
#							pass
#					$director.use_skill_for_player(select_skill_type, grid_pos)
#				else:
#					pass
#				$HUD/left_panel.disable_action_button()
#
#			print(1)
#			$stage/containers.lock_select_grid(false)
#
#func shit(grid_pos, container_status):
#	if container_status == true:
#		$HUD/left_panel.enable_grid_based_button()
#		$HUD/left_panel.disable_choice_node()
#		var action_status = yield($HUD/left_panel, \
#			"on_grid_based_button_pressed")
#		if action_status == "throw":
#			var handled = true
#			if not Que.try_event(Que.action_cost_energy, true):
#				handled = false
#				Infos.refresh_messager_info("action_failed", \
#					[action_status, str(grid_pos), "do not have energy"])
#				if not $director.try_throw_piece_for_player(grid_pos, true):
#					Infos.refresh_messager_info("action_failed", \
#						[action_status, str(grid_pos), "piece do not exist"])
#			if handled:
#				Que.try_event(Que.action_cost_energy, false) 
#				$stage/containers.throw_piece_in_stage(grid_pos)
#				Infos.refresh_player_info()
#			else:
#				$stage/containers.lock_select_grid_in_tilemap(false)
#		else:
#			var skill_type = yield($HUD/left_panel/skill_button, \
#				"on_skill_selected")
#			$director.try_skill_for_player(skill_type, grid_pos)
#	else:
#		$HUD/left_panel.disable_grid_based_button()
#		$HUD/left_panel.enanble_choice_node()
#
#		var type = yield($HUD/left_panel/choice_node, \
#			"on_piece_type_selected")
#		var handled = true
#		if not $director.in_own_field(Que.cur_player_index, grid_pos):
#			handled = false
#			Infos.refresh_messager_info("action_failed", \
#				["put", str(grid_pos), "not own field"])
#			if not Que.get_cur_player().pieces_num[type] > 0:
#				handled = false
#				Infos.refresh_messager_info("action_failed", \
#					["put", str(grid_pos), "do not have this piece"])
#				if not Que.try_event(Que.piece_cost_energy[type], true):
#					handled = false
#					Infos.refresh_messager_info("action_failed", \
#						["put", str(grid_pos), "do not have energy"])
#		if handled:
#			Que.try_event(Que.piece_cost_energy[type], false)
#			$director.put_piece_for_player(type, grid_pos)
#			$stage/containers.put_piece_in_stage(type, grid_pos)
#			Infos.refresh_player_info()
#			Infos.refresh_messager_info("action_succeed", \
#				["put", str(grid_pos)])
#		else:
#			$stage/containers.lock_select_grid_in_tilemap(false)

func play_in_turn():
	var last_signal = [InputSignals.signals.End_turn,[]]
	var new_signal = yield(InputSignals, "input_signal")
	var is_skill_need_extra_input = false
	$HUD/left_panel/action_buttons.enable_all_action_button()
	$stage/containers.extra_select_grid_status = "no"

	while new_signal[0] != InputSignals.signals.End_turn:
		var signal_type = new_signal[0]
		var buf = new_signal[1]
		if $stage/containers.select_grid_locked:
			$stage/containers.lock_select_grid(false)
		match(signal_type):
			InputSignals.signals.Select_grid_pos:
				var select_grid_pos = buf[0]
				var container_status = buf[1]
				
				print("select grid pos" + str(select_grid_pos))
				
				$stage/containers.lock_select_grid()
				if last_signal[0] == InputSignals.signals.Select_grid_pos:
					$stage/containers.lock_select_grid(false)
				if not is_skill_need_extra_input:
					$stage/containers.extra_select_grid_status = "no"
				if last_signal[0] == InputSignals.signals.Select_skill and \
					is_skill_need_extra_input:
					var handled = $director.check_skill([select_grid_pos], true)
					if handled:
						$director.use_skill([select_grid_pos], true)
						$HUD/left_panel/action_buttons.enable_all_action_button()
						Infos.refresh_player_info()
						Infos.refresh_messager_info("action_succeed", \
							["skill" + str(last_signal[1][0]), str(select_grid_pos)])
					else:
						$stage/containers.lock_select_grid(false)
						new_signal = [InputSignals.signals.Empty,[]]
					$stage/containers.extra_select_grid_status = "no"
					$stage/containers.lock_select_grid(false)
					$HUD/left_panel.disable_action_button()
				else:
#					print([container_status, $director.belong_to(select_grid_pos), Que.cur_player_index])
					if container_status and \
						$director.belong_to(select_grid_pos) == Que.cur_player_index:
						$HUD/left_panel.enable_action_button()
						$HUD/left_panel.disable_choice_node()
					elif not container_status:
						$HUD/left_panel.disable_action_button()
						$HUD/left_panel.enable_choice_node()
					else:
						$HUD/left_panel.disable_action_button()
						$HUD/left_panel.disable_action_button()
			InputSignals.signals.Select_piece_choice:
				var select_piece_type = buf[0]
				if last_signal[0] == InputSignals.signals.Select_grid_pos:
					var grid_pos = last_signal[1][0]
					var handled = $director.check_put(select_piece_type, grid_pos)
				
					if handled:
						$director.put_piece_for_player(select_piece_type, grid_pos)
						$stage/containers.put_piece_in_stage(select_piece_type, grid_pos)
						
						Infos.refresh_player_info()
						Infos.refresh_messager_info("action_succeed", \
							["put", str(grid_pos)])
						$HUD/left_panel.disable_choice_node()
					else:
						new_signal = [InputSignals.signals.Empty,[]]
			InputSignals.signals.Select_skill:
				var select_skill_type = buf[0]
#				is_skill_need_extra_input = false
				$HUD/left_panel/action_buttons.disable_all_action_button()
				if last_signal[0] == InputSignals.signals.Select_grid_pos:
					var grid_pos = last_signal[1][0]
					is_skill_need_extra_input = $director.extra_input_for_skill( \
						select_skill_type, grid_pos) != "no"
					if is_skill_need_extra_input:
						$stage/containers.extra_select_grid_status = \
							$director.extra_input_for_skill(select_skill_type, grid_pos)
#						print("pre_grid_pos = " + str(grid_pos))
						$stage/containers.pre_grid_pos = grid_pos
						$director.pre_use_skill(select_skill_type, grid_pos)
					else:
						var handled = $director.check_skill([select_skill_type, grid_pos])
						if handled:
							$director.use_skill([select_skill_type, grid_pos])
							$HUD/left_panel/action_buttons.enable_all_action_button()
							Infos.refresh_player_info()
							Infos.refresh_messager_info("action_succeed", \
								["skill" + str(select_skill_type), str(grid_pos)])
						else:
							new_signal = [InputSignals.signals.Empty,[]]
				
		
		for player in Que.players:
			for data in player.get_all_health():
				if data[1] <= 0:
					$stage/containers.remove_piece_in_stage(data[0])
				else:
					$stage/containers.update_health(data[0], data[1])
		last_signal = new_signal
		new_signal = yield(InputSignals, "input_signal")
		print("new action")

func on_piece_put_handled():
	$HUD/left_panel.disable_choice_node()
	$HUD/left_panel/choice_node.disable_select_indicator()


func _on_end_turn_button_pressed():
	$director.end_turn()
	stage_playing = false


func _on_extra_select_indicator_unlocked():
	$stage/containers.extra_select_grid_locked = true
