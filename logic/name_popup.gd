extends AcceptDialog

func _on_visibility_changed():
	position.x = get_parent().get_parent().get_parent().size.x / 2 - size.x / 2
	position.y = get_parent().get_parent().get_parent().size.y / 2 - size.y / 2
