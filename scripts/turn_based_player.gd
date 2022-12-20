extends Node

class_name TurnBasedPlayer

signal turn_ready(player)
signal turn_pending(player)
signal turn_submitted(player)

enum State{
	Ready,      	# round start
	Pending,        # your turn
	Submitted,      # go to next
}

var state = State.Ready setget set_state, get_state

func set_state(new_state):
	state = new_state
	match(new_state):
		State.Ready: emit_signal("turn_ready", self)
		State.Pending: emit_signal("turn_pending", self)
		State.Submitted: emit_signal("turn_submitted", self)

func get_state():
	return state
