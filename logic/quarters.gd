extends Control

func set_quarters(quarters_data):
	for i in range(4):
		get_child(i).set_match_data("quarter_finals", i, quarters_data[i])
