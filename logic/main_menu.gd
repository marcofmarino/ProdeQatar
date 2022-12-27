extends Control

signal exit_menu
signal user_list_received
signal request_add
signal user_selected

func set_users_list(users_list):
	emit_signal("user_list_received", users_list)

func _on_exit_pressed():
	emit_signal("exit_menu")

func _on_load_pressed():
	$ButtonsArea.hide()
	$UsersList.show_test()

func _on_cancel_pressed():
	$UsersList.hide()
	$ButtonsArea.show()

func _on_add_pressed():
	emit_signal("request_add")

func _on_list_user_selected(user_name):
	emit_signal("user_selected", user_name)
