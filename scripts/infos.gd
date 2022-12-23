extends Node

# warning-ignore:unused_argument
func get_info(info_name):
	pass

func refresh_round_info(index):
	var round_info = get_node("/root/Main/HUD/left_panel/round_label")
	round_info.text = "round: %d" % [index]

func refresh_player_info():
	for index in range(2):
		var player_info = get_node("/root/Main/HUD/left_panel/player_info" \
			 + str(index + 1))
		var cur_player = Que.players[index]
		player_info.get_node("name_label").text = \
			"player:%s" %[cur_player.pname]
		player_info.get_node("have_label").text = \
			"%dB %dG %dY" % cur_player.pieces_num
		player_info.get_node("energy_label").text = \
			"energy:%d" % [cur_player.energy]
		
#		print("player %d refreshed" % [index + 1])

func refresh_messager_info(message_pre, messages):
	var message_label = get_node("/root/Main/HUD/left_panel/message_label")
	var txt = message_label.text + '\n'
	
	match(message_pre):
		"new_player":
			message_label.text = \
				"player %s(index %d)'s turn" % [messages[1], messages[0]]
		"action_failed":
			message_label.text = txt + \
				"failed to %s at %s because: %s" % messages
			pass
		"action_succeed":
			message_label.text = txt + \
				"%s at %s" % messages
			pass
		_:
			push_error("wrong type of message")
#	match(message_type):
#		"add":
#			if message_label.text.count('\n') >= 8:
#				message_label.text = "cleared" + '\n' + message
#			message_label.text = message_label.text + '\n' + message
#		"new":
#			message_label.text = message

func _ready():
	pass
