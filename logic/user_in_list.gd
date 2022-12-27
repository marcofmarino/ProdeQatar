extends Button

signal i_was_selected

func _on_pressed():
	emit_signal("i_was_selected", text)
