extends Control

signal exit
signal go_to_menu
signal groups
signal knockout
signal export
signal update
signal export_update

func set_user_name(user_name):
	$UserName.text = user_name

func set_stages_state(stages_data):
	if stages_data[3]:
		$UpdateExport.visible = true
		$Export.visible = false
	elif stages_data[2]:
		$Export.visible = true
	else:
		$UpdateExport.visible = false
		$Export.visible = false
	for i in range(3):
		$Options.get_child(0).get_children()[i].disabled = not stages_data[i]

func _on_back_pressed():
	emit_signal("go_to_menu")

func _on_exit_pressed():
	emit_signal("exit")

func _on_groups_pressed():
	emit_signal("groups")

func _on_knockout_pressed():
	emit_signal("knockout")	

func _on_export_pressed():
	emit_signal("export")

func _on_update_pressed():
	emit_signal("update")

func _on_update_export_pressed():
	emit_signal("export_update")
