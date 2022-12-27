extends Button

signal check

var priority_value

func reset_value():
	priority_value = -1
	text = "-"

func get_priority_value():
	return priority_value

func _on_pressed():
	priority_value = get_parent().get_parent().get_parent().give_priority(priority_value)
	emit_signal("check")
	if priority_value == 0:
		text = "-"
	else:
		text = String.num_int64(priority_value)
