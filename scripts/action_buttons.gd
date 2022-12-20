extends Node2D

func _ready():
	pass

func disable_all_action_button():
	for item in get_children():
		item.disabled = true

func enable_all_action_button():
	for item in get_children():
		item.disabled = false

func _on_throw_button_pressed():
	InputSignals.emits(InputSignals.signals.Select_skill, [0])


func _on_skill_button1_pressed():
	InputSignals.emits(InputSignals.signals.Select_skill, [1])


func _on_skill_button2_pressed():
	InputSignals.emits(InputSignals.signals.Select_skill, [2])
