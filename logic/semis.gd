extends Control

func set_semis(semis_data):
	for i in range(2):
		get_child(i).set_match_data("semi_finals", i, semis_data[i])
