extends Panel

func _ready():
	pass

func enable_put_button():
	$put_button.visible = true

func disable_put_button():
	$put_button.visible = false

func enable_choice_node():
	$choice_node.visible = true

func disable_choice_node():
	$choice_node.visible = false

func enable_action_button():
	$action_buttons.visible = true

func disable_action_button():
	$action_buttons.visible = false

func set_round_label(index):
	$round_label.text = "round " + str(index)

func _on_end_turn_button_pressed():
	InputSignals.emits(InputSignals.signals.End_turn, [])
