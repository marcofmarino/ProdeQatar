extends VBoxContainer

var user_in_list = preload("res://scenes/user_in_list.tscn")
var theme_button
var users_list

signal user_selected

func update_list():
	clear_childrens()
	for user in users_list:
		var user_button = user_in_list.instantiate()
		user_button.text = user
		user_button.i_was_selected.connect(_user_selected)
		add_child(user_button)

func clear_childrens():
	for children in get_children():
		remove_child(children)
		
func _user_selected(user_name):
	emit_signal("user_selected", user_name)

func _on_main_menu_user_list_received(list):
	users_list = list
	update_list()
