extends Control

signal name_setted
signal cancel

func hide_cancel():
	$EnterName.hide_cancel()

func _on_user_name_name_setted(name):
	emit_signal("name_setted", name)

func _on_cancel_user_pressed():
	emit_signal("cancel")
