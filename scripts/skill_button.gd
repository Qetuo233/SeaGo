extends Button

signal on_skill_selected(type)

func _ready():
	pass


func _on_skill_button1_pressed():
	emit_signal("on_skill_selected", 0)


func _on_skill_button2_pressed():
	emit_signal("on_skill_selected", 1)


func _on_skill_button3_pressed():
	emit_signal("on_skill_selected", 2)
