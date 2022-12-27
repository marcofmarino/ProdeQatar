extends Control

signal group_selected
signal back_to_stage_selector
signal exit
signal all_groups_setted

func set_groups_state(groups_state):
	var count = 0
	for i in range(8):
		if groups_state[i]:
			count += 1
			get_children()[i].hide()
	if count == 8:
		emit_signal("all_groups_setted")

func _on_back_pressed():
	emit_signal("back_to_stage_selector")


func _on_exit_pressed():
	emit_signal("exit")


func _on_button_ga_pressed():
	emit_signal("group_selected", 0)


func _on_button_gb_pressed():
	emit_signal("group_selected", 1)


func _on_button_gc_pressed():
	emit_signal("group_selected", 2)


func _on_button_gd_pressed():
	emit_signal("group_selected", 3)


func _on_button_ge_pressed():
	emit_signal("group_selected", 4)


func _on_button_gf_pressed():
	emit_signal("group_selected", 5)


func _on_button_gg_pressed():
	emit_signal("group_selected", 6)


func _on_button_gh_pressed():
	emit_signal("group_selected", 7)
