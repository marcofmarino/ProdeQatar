extends Control

func set_games(round_data):
	for i in range(8):
		get_children()[i].set_match_data("round_of_16", i, round_data[i])
