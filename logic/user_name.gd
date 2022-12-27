extends LineEdit

signal name_setted

func _on_text_submitted(_new_text):
	_name_comprobation()

func _name_comprobation():
	if text.to_pascal_case() == "":
		$AcceptDialog.title = "Alerta: Nombre"
		$AcceptDialog.get_child(0).text = "No se puede dejar el nombre en blanco."
		$AcceptDialog.show()
	elif not text.is_valid_filename():
		$AcceptDialog.title = "Alerta: Nombre"
		$AcceptDialog.get_child(0).text = "No se pueden utilizar caracteres especiales."
		$AcceptDialog.show()
	else:
		var name = text
		text = ""
		emit_signal("name_setted", name)

func _on_add_user_cancel():
	text = ""
