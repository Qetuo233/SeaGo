extends Node


signal pre_round_started(index)
signal pre_round_ended(index)
signal game_started()
signal game_ended()

onready var player_index = 0
onready var round_index = 0
onready var game_status = true
onready var winner_index = 0

func _ready():
	pass

func pre_play():
	pass

func play():
	player_index = 0
	round_index = 0
	
	while not is_game_end():
		round_index += 1
		
		emit_signal("pre_round_started", round_index)
		
		for i in range(len(Que.players)):
			var p = Que.players[i]
			Que.cur_player_index = i
			get_parent().get_node("director").start_turn()
			
			yield(get_parent().play_in_turn(), "completed")
			p.state = TurnBasedPlayer.State.Ready
			p.state = TurnBasedPlayer.State.Pending
			
#			yield(p, "turn_submitted")
		
		
		emit_signal("pre_round_ended", round_index)
	print("player %d win!" % [winner_index])
	emit_signal("game_ended")

func is_game_end():
	return (not game_status) and (round_index <= 90)

func _on_director_player_losed(player_index):
	game_status = false
	winner_index = 1 - player_index
