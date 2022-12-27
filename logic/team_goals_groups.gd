extends LineEdit

signal goals_setted

func reset():
	text = ""

func _on_text_changed(new_text):
	if text == "":
		emit_signal("goals_setted", 0, false)
	elif not text.is_valid_int():
		delete_char_at_caret()
	else:
		emit_signal("goals_setted", text.to_int(), true)
